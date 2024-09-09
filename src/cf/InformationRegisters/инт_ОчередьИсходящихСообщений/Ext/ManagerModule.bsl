﻿////////////////////////////////////////////////////////////////////////////////

// <ОчередьИсходящихСообщений>

//  

////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция - Зарегистрировать сообщение
//
// Параметры:
//  ИсходныеДанные      -  ОпределяемыйТип.инт_ИсходныеДанные  - Ссылка на объект, или же фиксированная структура содержащая исходные данные для формирования сообщения
//  ПотокДанных         -  СправочникСсылка.инт_ПотокиДанных   - Ссылка на поток данных.
// ВозвращаемоеЗначение:
//  УникальныйИдентификатор, Неопределено - Возвращает идентификатор сообщения, или неопределено, если что-то пошло не так. 
Функция ЗарегистрироватьСообщение(ИсходныеДанные, ПотокДанных) Экспорт
   ИдентификаторСообщения = Неопределено;
    Если НЕ ПотокДанных.Активен Тогда
        // Поток не активен. Регистрация не будет работать.
    	Возврат ИдентификаторСообщения;
    КонецЕсли;
    Если Не ПотокДанных.НаправлениеПотока = Перечисления.инт_НаправлениеПотокаДанных.Исходящий Тогда
        СообщениеОбОшибке = СтрШаблон("При регистрации сообщения по потоку <%1>, для исходных данных <%2> произошла ошибка!
        |
        | Информация об ошибке: %3",ПотокДанных.Код, ИсходныеДанные, "Нельзя регистрировать в очереди исходящих сообщений входящие потоки!");
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ОчередьИсходящихСообщений",УровеньЖурналаРегистрации.Ошибка,,ИсходныеДанные,СообщениеОбОшибке);
        Возврат ИдентификаторСообщения;
    КонецЕсли;

    НачатьТранзакцию();
    Попытка
        ИдентификаторСообщения = Новый УникальныйИдентификатор;
        Запись = РегистрыСведений.инт_ОчередьИсходящихСообщений.СоздатьМенеджерЗаписи();
        Запись.ИдентификаторСообщения = ИдентификаторСообщения;
        Запись.ПотокДанных = ПотокДанных;
        Запись.ИсходныеДанные = ИсходныеДанные;
        Запись.Записать();
        
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(Запись.ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.Новый);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        СообщениеОбОшибке = СтрШаблон("При регистрации сообщения по потоку <%1>, для исходных данных <%2> произошла ошибка!
        |
        | Информация об ошибке: %3",ПотокДанных.ИдентификаторПотока, ИсходныеДанные, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.ОчередьИсходящихСообщений",УровеньЖурналаРегистрации.Ошибка,,ИсходныеДанные,СообщениеОбОшибке);
        // Нельзя вызывать исключение, т.к. Это исключение может улететь напрямую пользователю и сломать ему запись!
        Возврат ИдентификаторСообщения;
    КонецПопытки;
    
    Возврат ИдентификаторСообщения;
КонецФункции

// Процедура - Сформировать сообщение по идентификатору
// Формирует сообщение по идентификатору и записывает его в регистр.
//
// Параметры:
//  ИдентификаторСообщения     -   УникальныйИдентификатор   - Идентификатор сообщения которое требуется сформировать.
//
Процедура СформироватьСообщениеПоИдентификатору(ИдентификаторСообщения) Экспорт
    СообщениеВОчереди = ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, "ИсходныеДанные,ПотокДанных");
    СформированноеСообщение = Справочники.инт_ПотокиДанных.СформироватьСообщениеПоПотоку(СообщениеВОчереди.ИсходныеДанные, СообщениеВОчереди.ПотокДанных);
    
    НачатьТранзакцию();
    Попытка
        ЗаписатьСформированноеСообщение(ИдентификаторСообщения, СформированноеСообщение);
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ГотовоКОтправке);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ОшибкаФормирования, ПодробноеПредставлениеОшибки);
        СообщениеОбОшибке = СтрШаблон("При попытке сформировать сообщение с идентификатором <%1> возникла ошибка.
        |
        |Информация об ошибке: %2", ИдентификаторСообщения, ПодробноеПредставлениеОшибки);
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
    КонецПопытки;
КонецПроцедуры

// Функция - Получить данные очереди по идентификатору
//
// Параметры:
//  ИдентификаторСообщения     -  УникальныйИдентификатор  -  Идентификатор сообщения по которому будут получены данные
//  СписокПолей                 - Строка                    - Строка содержащая перечисления полей перечисленных через запятую.
// 
// Возвращаемое значение:
//  Структура - Структура данных сообщения. См. функцию ПолучитьШаблонСтруктурыСообщенияОчереди
//
Функция ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, СписокПолей) Экспорт
	СтруктураСообщения = Новый Структура;
    
    МассивПолей = СтрРазделить(СписокПолей, ",",Ложь);
    Если МассивПолей.Количество() = 0 Тогда
    	ВызватьИсключение "Список полей - не может быть пустым!";
    КонецЕсли;
    ШаблонПоля = "    инт_ОчередьИсходящихСообщений.%1 КАК %1";
    ТекстВыборка = "";
    ЭтоПервоеПоле = Истина;
    Для Каждого Поле Из МассивПолей Цикл
        ТекстВыборка = ТекстВыборка + ?(ЭтоПервоеПоле, "", ",") + Символы.ПС + СтрШаблон(ШаблонПоля, СокрЛП(Поле));
        ЭтоПервоеПоле = Ложь;
    КонецЦикла;
    
    Запрос = Новый Запрос;
    Запрос.Текст = СтрШаблон("ВЫБРАТЬ
                   |    %1
                   |ИЗ
                   |    РегистрСведений.инт_ОчередьИсходящихСообщений КАК инт_ОчередьИсходящихСообщений
                   |ГДЕ
                   |    инт_ОчередьИсходящихСообщений.ИдентификаторСообщения = &ИдентификаторСообщения", ТекстВыборка);
    Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
    Выборка = Запрос.Выполнить().Выбрать();
    Если выборка.Следующий() Тогда
            
        Для Каждого Поле Из МассивПолей Цикл
           	    СтруктураСообщения.Вставить(СокрЛП(Поле), ?(СокрЛП(Поле)="СформированноеСообщение", Выборка[СокрЛП(Поле)].Получить(), Выборка[СокрЛП(Поле)]));
        КонецЦикла;
    КонецЕсли;
    Возврат СтруктураСообщения;
КонецФункции

// Процедура - Зарегистрировать сообщение к отправке
//
// Параметры:
//  ИдентификаторСообщения     -   УникальныйИдентификатор   - Идентификатор сообщения которое требуется отметить к отправке 
//
Процедура ЗарегистрироватьСообщениеКОтправке(ИдентификаторСообщения) Экспорт
    СообщениеВОчереди = ПолучитьДанныеОчередиПоИдентификатору(ИдентификаторСообщения, "ПотокДанных");
    МассивПодписчиков = Справочники.инт_ПотокиДанных.ПолучитьПодписчиковПоПотоку(СообщениеВОчереди.ПотокДанных);
    НачатьТранзакцию();
    Попытка
        РегистрыСведений.инт_ОчередьОтправкиИсходящихСообщений.ЗарегистрироватьСообщениеКРассылкеПодписчикам(ИдентификаторСообщения, МассивПодписчиков);
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ПомещеноВОчередьОтправки);
        ЗафиксироватьТранзакцию();
    Исключение
        ОтменитьТранзакцию();
        ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
        СообщениеОбОшибке = СтрШаблон("При попытке поместить сообщение с идентификатором <%1> в очередь отправки возникла ошибка.
        |
        |Информация об ошибке: %2", ИдентификаторСообщения, ПодробноеПредставлениеОшибки);
        РегистрыСведений.инт_ТекущийСтатусИсходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Перечисления.инт_СтатусыИсходящихСообщений.ОшибкаОтправки, ПодробноеПредставлениеОшибки);
        ЗаписьЖурналаРегистрации("ПодсистемаИнтеграции.МенеджерПотоковФормированияСообщений", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
        ВызватьИсключение;
    КонецПопытки;
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьСформированноеСообщение(ИдентификаторСообщения, СформированноеСообщение)
  	Запись = РегистрыСведений.инт_ОчередьИсходящихСообщений.СоздатьМенеджерЗаписи();
    Запись.ИдентификаторСообщения = ИдентификаторСообщения;
    Запись.Прочитать();
    Запись.СформированноеСообщение = Новый ХранилищеЗначения(СформированноеСообщение, Новый СжатиеДанных(9));
    Запись.Записать(Истина);
КонецПроцедуры
  
Функция ПолучитьШаблонСтруктурыСообщенияОчереди()
	Возврат Новый Структура("ИдентификаторСообщения, ИсходныеДанные, ПотокДанных, СформированноеСообщение",
                                            Новый УникальныйИдентификатор,
                                            Неопределено,
                                            Справочники.инт_ПотокиДанных.ПустаяСсылка(),
                                            Новый Соответствие);
КонецФункции

#КонецОбласти

#КонецЕсли
