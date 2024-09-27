﻿#Область ПрограммныйИнтерфейс

Процедура ОткрытьПреобразоватьВоВложенный(Форма, Элемент, ЗаголовокПредупреждения, ОписаниеОповещенияОЗавершении = Неопределено) Экспорт
	
	Заголовок = НСтр("ru = 'Введите идентификатор для вложенного запроса'; en = 'Enter id for subquery'");
	Режим = ИТКВ_Перечисления.РежимРедактированияИдентификатораИдентификатор();
	ИдентификаторПоУмолчанию = НСтр("ru = 'ВложенныйЗапрос'; en = 'SubQuery'");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОписаниеОповещенияОЗавершении);
	ДополнительныеПараметры.Вставить("ЗаголовокПредупреждения", ЗаголовокПредупреждения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВводИдентификатораВложенногоЗапросаЗавершен", ЭтотОбъект, ДополнительныеПараметры);
	
	ВыделенныйТекст = ИТКВ_РедакторКодаКлиент.ВыделенныйТекст(Элемент);
	
	РезультатПреобразования = ИТКВ_ЗапросВызовСервера.ПреобразоватьТекстЗапросаВоВложенный(ВыделенныйТекст, ИдентификаторПоУмолчанию);
	Если ЗначениеЗаполнено(РезультатПреобразования.Ошибка) Тогда
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ИдентификаторПоУмолчанию);
		
	Иначе
		
		ИТКВ_ФормаКлиент.ОткрытьРедактированиеИдентификатора(Заголовок, Режим, Форма, ОписаниеОповещения, ИдентификаторПоУмолчанию);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВводИдентификатораВложенногоЗапросаЗавершен(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	
	ВыделенныйТекст = ИТКВ_РедакторКодаКлиент.ВыделенныйТекст(Элемент);
	РезультатПреобразования = ИТКВ_ЗапросВызовСервера.ПреобразоватьТекстЗапросаВоВложенный(ВыделенныйТекст, Результат);
	
	Если ЗначениеЗаполнено(РезультатПреобразования.Ошибка) Тогда
		
		ПоказатьПредупреждение( , РезультатПреобразования.Ошибка, , ДополнительныеПараметры.ЗаголовокПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	ГраницыВыделения = ИТКВ_РедакторКодаКлиент.ГраницыВыделения(Элемент);
	НачалоСтроки = ГраницыВыделения.НачалоСтроки;
	НачалоКолонки = ГраницыВыделения.НачалоКолонки;
		
	НовыйТекст = ИТКВ_ЗапросКлиентСервер.СкорректироватьТабуляциюВставляемогоТекста(РезультатПреобразования.Текст, ВыделенныйТекст);
	ИТКВ_РедакторКодаКлиент.УстановитьВыделенныйТекст(Элемент, НовыйТекст, ГраницыВыделения);
	НовыйТекст = ИТКВ_РедакторКодаКлиент.Текст(Форма, Элемент.Имя);
	
	// Вернем выделение текста
	ГраницыВыделения = ИТКВ_РедакторКодаКлиент.ГраницыВыделения(Элемент);
	ИТКВ_РедакторКодаКлиент.УстановитьГраницыВыделения(Элемент, НачалоСтроки, НачалоКолонки, ГраницыВыделения.КонецСтроки, ГраницыВыделения.КонецКолонки);
	
	ОповещениеОЗавершении = ДополнительныеПараметры.ОповещениеОЗавершении;
	Если ОповещениеОЗавершении <> Неопределено Тогда
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, НовыйТекст);
		
	КонецЕсли;

	ИТКВ_РедакторКодаКлиент.ПодключитьОбработчикОжиданияВосстановлениеФокуса(Форма);
	
КонецПроцедуры

Процедура ОткрытьВставкуПредопределенного(Форма, Элемент) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВставкаПредопределенногоЗакончена", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ИТКВ_КонсольРазработчика.Форма.ВставкаПредопределенногоЭлемента", , Форма, , , ,
													ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ВставкаПредопределенногоЗакончена(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	Элемент = ДополнительныеПараметры.Элемент;
	ИТКВ_РедакторКодаКлиент.УстановитьВыделенныйТекст(Элемент, Результат);
	
	ИТКВ_РедакторКодаКлиент.ПодключитьОбработчикОжиданияВосстановлениеФокуса(Форма);

КонецПроцедуры

Процедура ОткрытьКонструктор(Знач Текст, Оповещение, РежимКомпоновкиДанных = Ложь) Экспорт
	
	Попытка
		
		ЗапуститьКонструктор(Текст, Оповещение, РежимКомпоновкиДанных);
		
	Исключение
		
 		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		РедактируетсяВыделенныйТекст = ИТКВ_ОбщийКлиентСервер.Свойство(Оповещение.ДополнительныеПараметры, "РедактируетсяВыделенныйТекст", Ложь);
		
		Если РедактируетсяВыделенныйТекст Тогда
			ПоказатьПредупреждение( , КраткоеПредставлениеОшибки, , ИТКВ_КонсольРазработчикаКлиентСервер.Представление());
			Возврат;
		КонецЕсли;
		
		ЧастиТекстаВопроса = Новый Массив;
		ЧастиТекстаВопроса.Добавить(НСтр("ru = 'В запросе содержатся ошибки:'; en = 'The request contains errors:'"));
		ЧастиТекстаВопроса.Добавить(Символы.ПС);
		ЧастиТекстаВопроса.Добавить(Новый ФорматированнаяСтрока(КраткоеПредставлениеОшибки, ИТКВ_ОбщийКлиентСервер.ШрифтЖирный()));
		ЧастиТекстаВопроса.Добавить(Символы.ПС);
		ЧастиТекстаВопроса.Добавить(НСтр("ru = 'текст запроса будет потерян. Продолжить?'; en = 'The query text will be lost. Continue?'"));
		ТекстВопроса = Новый ФорматированнаяСтрока(ЧастиТекстаВопроса);
			
		ЗаголовокВопроса = НСтр("ru = 'Запуск конструктора запроса'; en = 'Run the query constructor'");
		КнопкиВопроса = ИТКВ_ФормаКлиент.КнопкиВопросаПродолжитьОтмена();
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Текст", Текст);
		ДополнительныеПараметры.Вставить("Оповещение", Оповещение);
		ДополнительныеПараметры.Вставить("РежимКомпоновкиДанных", РежимКомпоновкиДанных);
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросТекстБудетПотерянЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ИТКВ_ФормаКлиент.ЗадатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, КнопкиВопроса, Истина, ЗаголовокВопроса, ЭтотОбъект);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ВопросТекстБудетПотерянЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = ДополнительныеПараметры.Оповещение;
	РежимКомпоновкиДанных = ДополнительныеПараметры.РежимКомпоновкиДанных;
	ЗапуститьКонструктор("", Оповещение, РежимКомпоновкиДанных);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗапуститьКонструктор(Знач Текст, Оповещение, РежимКомпоновкиДанных = Ложь)
	
	Текст = СокрЛП(Текст); // При передачи в конструктор пустого текста сообщает об ошибке
	
	ВсеНастройки = ИТКВ_НастройкиВызовСервера.ЗагрузитьВсе();
	ОбщиеНастройки = ВсеНастройки[ИТКВ_НастройкиКлиентСервер.ИмяРеквизитаНастройкиОбщие()];
	
	// Определение типа конструктора
	#Если ТолстыйКлиентУправляемоеПриложение Тогда
		ИмяНастройки = "КонструкторЗапросаТолстогоКлиента";
	#Иначе
		ИмяНастройки = "КонструкторЗапросаТонкогоКлиента";
	#КонецЕсли
	ТипКонструктора = ОбщиеНастройки[ИмяНастройки];
	Если ИТКВ_ТуллкитКлиентСервер.ОграниченнаяВерсия()
			И ТипКонструктора = ИТКВ_Перечисления.ТипКонструктораЗапросаУлучшенныйТонкий() Тогда
			
		ТипКонструктора = ИТКВ_Перечисления.ТипКонструктораЗапросаТонкий();
		
	КонецЕсли;
	
	// Запуск конструктора
	Если ТипКонструктора = ИТКВ_Перечисления.ТипКонструктораЗапросаТолстый() Тогда
		
		КонструкторЗапроса = Новый КонструкторЗапроса;
		КонструкторЗапроса.РежимКомпоновкиДанных = РежимКомпоновкиДанных;
		
		Если ЗначениеЗаполнено(Текст) Тогда
			
			КонструкторЗапроса.Текст = Текст;
			
		КонецЕсли;
		
		Если КонструкторЗапроса.ОткрытьМодально() Тогда
			
			ВыполнитьОбработкуОповещения(Оповещение, КонструкторЗапроса.Текст);

		КонецЕсли;
		
	ИначеЕсли ТипКонструктора = ИТКВ_Перечисления.ТипКонструктораЗапросаУлучшенныйТонкий() Тогда
		
		ЗапуститьУлучшенныйКонструкторТонкогоКлиента(Текст, Оповещение, РежимКомпоновкиДанных);
		
	ИначеЕсли ТипКонструктора = ИТКВ_Перечисления.ТипКонструктораЗапросаТонкий() Тогда
		
		ЗапуститьСтандартныйКонструкторТонкогоКлиента(Текст, Оповещение, РежимКомпоновкиДанных);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапуститьСтандартныйКонструкторТонкогоКлиента(Текст, Оповещение, РежимКомпоновкиДанных)
	
	КонструкторЗапроса = Новый КонструкторЗапроса;
	КонструкторЗапроса.РежимКомпоновкиДанных = РежимКомпоновкиДанных;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		КонструкторЗапроса.Текст = Текст;
		
	КонецЕсли;
	
	КонструкторЗапроса.Показать(Оповещение);
	
КонецПроцедуры

Процедура ЗапуститьУлучшенныйКонструкторТонкогоКлиента(Текст, Оповещение, РежимКомпоновкиДанных)
	
	ПолноеИмяФормы = ИТКВ_КонструкторЗапросовВызовСервера.ПолноеИмяФормыОбработки();
	Если ЗначениеЗаполнено(ПолноеИмяФормы) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("QueryText", Текст);
		ПараметрыФормы.Вставить("DataCompositionMode", РежимКомпоновкиДанных);
		
		Данные = ИТКВ_ОбщийКлиентСервер.Свойство(Оповещение.ДополнительныеПараметры, "Данные");
		ПараметрыФормы.Вставить("Данные", Данные);
		
		ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы, ЭтотОбъект, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ЗапуститьСтандартныйКонструкторТонкогоКлиента(Текст, Оповещение, РежимКомпоновкиДанных);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
