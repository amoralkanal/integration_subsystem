﻿#Область ПрограммныйИнтерфейс

// Возвращает представление
//
// Возвращаемое значение:
//   Строка	- Представление
//
Функция Представление() Экспорт
	
	Возврат НСтр("ru = 'Конструктор схемы компоновки данных'; en = 'Data composition schema designer'");
	
КонецФункции

Функция КартинкаНабораДанных(Тип) Экспорт
	
	Если Тип = ИТКВ_Перечисления.СКДНаборДанныхЗапрос() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_СКДНаборДанныхЗапрос;
		
	ИначеЕсли Тип = ИТКВ_Перечисления.СКДНаборДанныхОбъект() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_СКДНаборДанныхОбъект;
		
	ИначеЕсли Тип = ИТКВ_Перечисления.СКДНаборДанныхОбъединение() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_СКДНаборДанныхОбъединение;
		
	Иначе
		
		Результат = Новый Картинка;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КартинкаПоляНабораДанных(Вид) Экспорт
	
	Если Вид = ИТКВ_Перечисления.СКДВидыПолейНаборовДанныхПоле() Тогда
		
		Результат = БиблиотекаКартинок.Реквизит;
		
	ИначеЕсли Вид = ИТКВ_Перечисления.СКДВидыПолейНаборовДанныхНабор() Тогда
		
		Результат = БиблиотекаКартинок.ВложеннаяТаблица;
		
	Иначе
		
		Результат = БиблиотекаКартинок.ИТКВ_Папка;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КартинкаМакета(Тип) Экспорт
	
	Если Тип = ИТКВ_Перечисления.СКДМакетПоля() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_СКДМакетПоля;
		
	ИначеЕсли Тип = ИТКВ_Перечисления.СКДМакетГруппировки() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_СКДМакетГруппировки;
		
	ИначеЕсли Тип = ИТКВ_Перечисления.СКДМакетЗаголовкаГруппировки() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_СКДМакетЗаголовкаГруппировки;
		
	ИначеЕсли Тип = ИТКВ_Перечисления.СКДМакетРесурсов() Тогда
		
		Результат = БиблиотекаКартинок.ИТКВ_СКДМакетРесурсов;
		
	Иначе
		
		Результат = Новый Картинка;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПрефиксИмениНовогоИсточника() Экспорт
	
	Возврат НСтр("ru = 'ИсточникДанных'; en = 'DataSource'");
	
КонецФункции

Функция ПрефиксИмениНовогоПоляНабораДанных(Вид) Экспорт
	
	Если Вид = ИТКВ_Перечисления.СКДВидыПолейНаборовДанныхГруппа() Тогда
		
		Результат = НСтр("ru = 'Группа'; en = 'Group'");
		
	ИначеЕсли Вид = ИТКВ_Перечисления.СКДВидыПолейНаборовДанныхПоле() Тогда
		
		Результат = НСтр("ru = 'Поле'; en = 'Field'");
		
	Иначе
		
		Результат = НСтр("ru = 'Набор'; en = 'Set'");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПрефиксИмениНовогоПараметра() Экспорт
	
	Возврат НСтр("ru = 'Параметр'; en = 'Parameter'");
	
КонецФункции

Функция ПрефиксИмениНовойВложеннойСхемы() Экспорт
	
	Возврат НСтр("ru = 'Отчет'; en = 'Report'");
	
КонецФункции

Функция ПрефиксИмениНовогоВариантаНастроек() Экспорт
	
	Возврат НСтр("ru = 'Вариант'; en = 'Variant'");
	
КонецФункции

#КонецОбласти
