﻿#Область ПрограммныйИнтерфейс

Функция ТипВсеСсылкиКоллекции(Имя) Экспорт
	
	Если ИТКВ_Строки.НекорректныйИдентификатор(Имя) Тогда
		ВызватьИсключение "Некорректное имя менеджера";
	КонецЕсли;
	
	Менеджер = МенеджерПоИмени(Имя);
	
	Возврат Менеджер.ТипВсеСсылки();
	
КонецФункции

Функция ОписаниеСсылочныхТипов() Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Имя");
	Результат.Колонки.Добавить("Менеджер");
	Результат.Колонки.Добавить("Метаданные");
	
	ДобавитьОписаниеСсылочногоТипа(Результат, "Справочник");
	ДобавитьОписаниеСсылочногоТипа(Результат, "Документ");
	ДобавитьОписаниеСсылочногоТипа(Результат, "ПланВидовХарактеристик");
	ДобавитьОписаниеСсылочногоТипа(Результат, "ПланСчетов");
	ДобавитьОписаниеСсылочногоТипа(Результат, "ПланВидовРасчета");
	ДобавитьОписаниеСсылочногоТипа(Результат, "ПланОбмена");
	ДобавитьОписаниеСсылочногоТипа(Результат, "БизнесПроцесс");
	ДобавитьОписаниеСсылочногоТипа(Результат, "Задача");

	Возврат Результат;
	
КонецФункции

Функция МенеджерПоИмени(Имя) Экспорт
	
	Если ИТКВ_Строки.НекорректныйИдентификатор(Имя) Тогда
		ВызватьИсключение "Некорректное имя менеджера";
	КонецЕсли;
	
	// Опасности не представляет т.к. это должен быть идентификатор и это проверяется выше
	// BSLLS:ExecuteExternalCodeInCommonModule-off
	Результат = Вычислить(Имя);
	// BSLLS:ExecuteExternalCodeInCommonModule-on
	
	Возврат Результат;
	
КонецФункции

Функция КэшФункциональныхОпций () Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ПолноеИмяОбъектаМетаданных", ИТКВ_ТипыКлиентСервер.ОписаниеСтрока());
	Результат.Колонки.Добавить("ИмяФункциональнойОпции", ИТКВ_ТипыКлиентСервер.ОписаниеИмяМетаданных());
	
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		
		ИмяФункциональнойОпции = ФункциональнаяОпция.Имя;
		Для Каждого СоставФункциональнойОпции Из ФункциональнаяОпция.Состав Цикл
			
			ОбъектВСоставе = СоставФункциональнойОпции.Объект;
			Если ОбъектВСоставе = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.ПолноеИмяОбъектаМетаданных = ОбъектВСоставе.ПолноеИмя();
			НоваяСтрока.ИмяФункциональнойОпции = ИмяФункциональнойОпции;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Добавляем индексы
	Результат.Индексы.Добавить("ПолноеИмяОбъектаМетаданных");
	
	Возврат Результат;
	
КонецФункции

Функция КэшИменКоллекции(Имя) Экспорт
	
	Результат = Новый СписокЗначений;
	
	Если ИТКВ_МетаданныеКлиентСерверПовтИсп.ЭтоОбработка(Имя)
			ИЛИ ИТКВ_МетаданныеКлиентСерверПовтИсп.ЭтоОтчет(Имя) Тогда
			
		ИмяПраваДоступа = "Использование";
		
	ИначеЕсли ИТКВ_МетаданныеКлиентСерверПовтИсп.ЭтоКритерийОтбора(Имя) Тогда
		
		ИмяПраваДоступа = "Просмотр";
		
	Иначе
		
		ИмяПраваДоступа = "Чтение";
		
	КонецЕсли;
	
	КоллекцияМетаданных = КоллекцияМетаданныхПоИмени(Имя);
	Для Каждого ОбъектМетаданных Из КоллекцияМетаданных Цикл
		
		Если ЗначениеЗаполнено(ИмяПраваДоступа)
				И НЕ ПравоДоступа(ИмяПраваДоступа, ОбъектМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Добавить(ОбъектМетаданных.Имя);
		
	КонецЦикла;

	Результат.СортироватьПоЗначению();
	
	Возврат Результат;
	
КонецФункции

Функция КэшПредставленийИИменКоллекции(Имя) Экспорт
	
	Результат = Новый СписокЗначений;
	
	КоллекцияМетаданных = Метаданные[Имя];
	Для Каждого ОбъектМетаданных Из КоллекцияМетаданных Цикл
		
		Результат.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Представление());
		
	КонецЦикла;

	Результат.СортироватьПоПредставлению();
	
	Возврат Результат;
	
КонецФункции

Функция КоллекцияМетаданныхПоИмени(Имя) Экспорт
	
	Если ИТКВ_МетаданныеКлиентСерверПовтИсп.ЭтоТочкаМаршрутаБизнесПроцесса(Имя) Тогда
		
		Результат = Метаданные.БизнесПроцессы;
		
	Иначе
		
		Результат = Метаданные[Имя];
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СуществуетОбщийМодуль(Имя) Экспорт
	
	Возврат (Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОписаниеСсылочногоТипа(Результат, Имя)
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.Имя = Имя;
	
	ИмяКоллекции = ИТКВ_МетаданныеКлиентСерверПовтИсп.ИмяКоллекции(Имя);
	НоваяСтрока.Менеджер = МенеджерПоИмени(ИмяКоллекции);
	
	НоваяСтрока.Метаданные = Метаданные[ИмяКоллекции];

КонецПроцедуры

#КонецОбласти
