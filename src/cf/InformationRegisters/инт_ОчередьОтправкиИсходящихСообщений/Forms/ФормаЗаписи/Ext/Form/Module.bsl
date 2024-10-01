﻿#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтотОбъект.СтатусСообщения = РегистрыСведений.инт_ТекущийСтатусРассылкиСообщений.ТекущийСтатусСообщения(
																	Запись.ИдентификаторСообщения, Запись.Подписчик);
																	
	ТекущаяЗаписьДляФормы = ПолучитьЗаписьРСПоКлючу(Запись.ИсходныйКлючЗаписи);
	СформированноеСообщениеДЗнач = ФормированиеСообщенияДеревоЗначений(ТекущаяЗаписьДляФормы);

	ЗначениеВРеквизитФормы(СформированноеСообщениеДЗнач, "СформированноеСообщение");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ФормированиеСообщенияДеревоЗначений(ТекущаяЗаписьДляФормы)
	
	СформированноеСообщениеСоотв = ТекущаяЗаписьДляФормы.СформированноеСообщение.Получить();
	
	СформированноеСообщениеДЗнач = Новый ДеревоЗначений;
	СформированноеСообщениеДЗнач.Колонки.Добавить("Ключ");
	СформированноеСообщениеДЗнач.Колонки.Добавить("Значение");
	
	СоответствиеВДерево(СформированноеСообщениеСоотв, СформированноеСообщениеДЗнач);
	
	Возврат СформированноеСообщениеДЗнач;
	
КонецФункции

&НаСервере
Процедура СоответствиеВДерево(Соответствие, СтрокаДерева)
	
	Если Тип("Соответствие") = ТипЗнч(Соответствие) Тогда
		ОбработатьСоответствие(Соответствие, СтрокаДерева);
	ИначеЕсли Тип("Массив") = ТипЗнч(Соответствие) Тогда
        ОбработатьМассив(Соответствие, СтрокаДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСоответствие(Соответствие, СтрокаДерева)
	
	Для Каждого Элемент	Из Соответствие Цикл
		ПодстрокаДерева		= СтрокаДерева.Строки.Добавить();
		ПодстрокаДерева.Ключ	= Элемент.Ключ;
		Если ТипЗнч(Элемент.Значение) = Тип("Строка") Тогда
			ПодстрокаДерева.Значение	= Элемент.Значение;
		Иначе
			СоответствиеВДерево(Элемент.Значение, ПодстрокаДерева)
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьМассив(Соответствие, СтрокаДерева)
	
	Для Инд = 0 По Соответствие.ВГраница() Цикл
		ПодстрокаДерева		= СтрокаДерева.Строки.Добавить();
		ПодстрокаДерева.Ключ	= "ЭлементМассива[" + Инд + "]";
		Если ТипЗнч(Соответствие[Инд]) = Тип("Строка") Тогда
			ПодстрокаДерева.Значение	= Соответствие[Инд];
		Иначе
			СоответствиеВДерево(Соответствие[Инд], ПодстрокаДерева)
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗаписьРСПоКлючу(КлючЗаписи)
		
	Запись = РегистрыСведений.инт_ОчередьИсходящихСообщений.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, КлючЗаписи);
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Возврат Запись;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

