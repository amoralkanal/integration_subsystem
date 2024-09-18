﻿#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Элементы.СписокОткрытьДетальнуюИнформацию.Пометка = Ложь;
	
	ОбновитьВидимостьГруппыДетальнаяИнформация();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьСтатус(Команда)
			
	ОткрытьФорму("Перечисление.инт_СтатусыВходящихСообщений.ФормаВыбора",,,,,,
				Новый ОписаниеОповещения("ИзменитьСтатусЗавершение", ЭтотОбъект));
									
КонецПроцедуры
			
&НаКлиенте
Процедура ИсторияСтатусов(Команда)
		
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторСообщения", Элементы.Список.ТекущиеДанные.ИдентификаторСообщения);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("РегистрСведений.инт_ИсторияСтатусовВходящихСообщений.ФормаСписка", ПараметрыФормы, ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДетальнуюИнформацию(Команда)
	
	Элементы.СписокОткрытьДетальнуюИнформацию.Пометка = НЕ Элементы.СписокОткрытьДетальнуюИнформацию.Пометка;
	
	ОбновитьВидимостьГруппыДетальнаяИнформация();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста)
Процедура ИзменитьСтатусНаСервере(Статус, ИдентификаторСообщения, ТекстОшибки)
		
    РегистрыСведений.инт_ТекущийСтатусВходящихСообщений.ЗаписатьСтатусСообщения(ИдентификаторСообщения, Статус, ТекстОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатусЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоОшибочныйСтатус(ВыбранныйЭлемент) Тогда
		ДополнительныеПараметры = Новый Структура("Статус", ВыбранныйЭлемент);
		ОповещениеТекстОшибки = Новый ОписаниеОповещения("ПослеВводаТекстаОшибки", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВводСтроки(ОповещениеТекстОшибки,, "Введите текст ошибки",, Истина);
	Иначе
		ИзменитьСтатусНаСервере(ВыбранныйЭлемент,
								Элементы.Список.ТекущиеДанные.ИдентификаторСообщения,
								Элементы.Список.ТекущиеДанные.ТекстОшибки);
	КонецЕсли;
	
	Элементы.Список.Обновить();
											
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьГруппыДетальнаяИнформация()
	
	Элементы.ГруппаДетальнаяИнформация.Видимость = Элементы.СписокОткрытьДетальнуюИнформацию.Пометка;
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Элементы.ГруппаДетальнаяИнформация.Доступность = Ложь;
	Иначе
		Элементы.ГруппаДетальнаяИнформация.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоОшибочныйСтатус(Статус)
	
	Возврат инт_СтатусыСообщенийПовтИсп.ЭтоОшибочныйСтатус(Статус);
	
КонецФункции

&НаКлиенте
Процедура ПослеВводаТекстаОшибки(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		
		ИзменитьСтатусНаСервере(ДополнительныеПараметры.Статус,
								Элементы.Список.ТекущиеДанные.ИдентификаторСообщения,
								Результат);
	Иначе
		Сообщить("Статус не был изменен");
		Возврат;
	КонецЕсли;
							
	Элементы.Список.Обновить();
		
КонецПроцедуры

#КонецОбласти
