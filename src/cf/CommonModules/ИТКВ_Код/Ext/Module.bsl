﻿#Область ПрограммныйИнтерфейс

// Получает код для запроса
//
// Параметры:
//  Данные  - Данные - Данные
//  Настройки  - Структура - Настройки генерации текста
//
// Возвращаемое значение:
//   Строка - код на встроенном языке для запроса
//
Функция Запрос(Данные, Настройки) Экспорт
	
	Язык = Настройки.Язык;
	ДобавлятьКомментарии = Настройки.ДобавлятьКомментарии;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Язык", Язык);
	ДополнительныеПараметры.Вставить("ДобавлятьКомментарии", ДобавлятьКомментарии);
	
	ТекстЗапроса = Данные.Текст;
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	КоличествоРезультатов = ИТКВ_Запрос.КоличествоВПакете(СхемаЗапроса, Ложь);
	
	СтрокиКода = Новый Массив;
	
	СтрокиКода.Добавить(НСтр("ru = 'Запрос = Новый Запрос;'; en = 'Query = New Query;'", Язык));
	Если Настройки.МенеджерВременныхТаблиц Тогда
		СтрокиКода.Добавить(НСтр("ru = 'Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;'; en = 'Query.TempTablesManager = New TempTablesManager;'", Язык));
	КонецЕсли;
	
	Если Настройки.Параметры Тогда
		ГенерироватьКодУстановкиПараметров(Данные, СтрокиКода, ДополнительныеПараметры);
	КонецЕсли;
	
	// Вставка текста запроса
	СтрокиКода.Добавить("");
	
	ТекстЗапросаНаВстроенномЯзыке = Значение(ТекстЗапроса, ДополнительныеПараметры);
	СтрокиКода.Добавить(СтрШаблон(НСтр("ru = 'Запрос.Текст =
                                        |%1;';
										|en = 'Query.Text =
                                        |%1;'", Язык), ТекстЗапросаНаВстроенномЯзыке));
	
	// Результат
	Если Настройки.ВидРезультата = ИТКВ_Перечисления.ВидРезультатаЗапросаПакет() И КоличествоРезультатов > 1 Тогда
		
		СтрокиКода.Добавить(НСтр("ru = 'ПакетРезультатов = Запрос.ВыполнитьПакет();'; en = 'ResultsPackage = Query.ExecuteBatch();'", Язык));
		
	Иначе
		
		СтрокиКода.Добавить(НСтр("ru = 'Результат = Запрос.Выполнить();'; en = 'Result = Query.Execute();'", Язык));
		
	КонецЕсли;
	
	Если Настройки.ПроверкаРезультата Тогда
		
		СтрокиКода.Добавить("");
		СтрокиКода.Добавить(НСтр("ru = 'Если Результат.Пустой() Тогда'; en = 'If Result.IsEmpty() Then'", Язык));
		
		Если Настройки.ВключитьВФункцию Тогда
			
			КодВозврата = НСтр("ru = 'Возврат Неопределено;'; en = 'Return Undefined;'", Язык);
			
		Иначе
			
			КодВозврата = НСтр("ru = 'Возврат;'; en = 'Return;'", Язык);
			
		КонецЕсли;
		
		СтрокиКода.Добавить(ИТКВ_Строки.ДобавитьТабВМногострочныйТекст(КодВозврата));
		
		СтрокиКода.Добавить(НСтр("ru = 'КонецЕсли;'; en = 'EndIf;'", Язык));
		
	КонецЕсли;
	
	Если Настройки.Выборка Тогда
		
		ГенерироватьКодВыборкиЗапроса(СхемаЗапроса, СтрокиКода, Настройки, Язык);
		
	КонецЕсли;
	
	Результат = СтрСоединить(СтрокиКода, Символы.ПС);
	
	Если Настройки.ВключитьВФункцию Тогда
		
		Шаблон = НСтр("ru = 'Функция %1()
		|
		|%2
		|
		|КонецФункции'; en = 'Function %1()
		|
		|%2
		|
		|EndFunction'", Язык);
		Результат = СтрШаблон(Шаблон, Настройки.ИмяФункции, ИТКВ_Строки.ДобавитьТабВМногострочныйТекст(Результат));
		
	КонецЕсли;
	
	Возврат	Результат;
	
КонецФункции

// Получает код для схемы компоновки данных
//
// Параметры:
//  Данные  - Данные - Данные
//  Настройки  - Структура - Настройки генерации текста
//
// Возвращаемое значение:
//   Строка - код на встроенном языке для схемы компоновки данных
//
Функция СхемаКомпоновкиДанных(Данные, Настройки) Экспорт
	
	Язык = Настройки.Язык;
	ДобавлятьКомментарии = Настройки.ДобавлятьКомментарии;
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Язык", ДобавлятьКомментарии);
	ДополнительныеПараметры.Вставить("ДобавлятьКомментарии", ДобавлятьКомментарии);
	
	// Инициализация
	СтрокиКода = Новый Массив;
	
	// Основной код
	СтрокиКода = Новый Массив;
	
	Если Настройки.ИспользуетсяВОтчете Тогда
		
		СтрокиКода.Добавить(НСтр("ru = 'СхемаКомпоновкиДанных = ПолучитьМакет(""ОсновнаяСхемаКомпоновкиДанных"");';
								|en = 'DataCompositionSchema = GetTemplate(""MainDataCompositionSchema"");'", Язык));
		СтрокиКода.Добавить("");
		СтрокиКода.Добавить(НСтр("ru = 'КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;';
								|en = 'SettingsComposer = New DataCompositionSettingsComposer;'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));';
								|en = 'SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(DataCompositionSchema));'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);';
								|en = 'SettingsComposer.LoadSettings(DataCompositionSchema.DefaultSettings);'", Язык));
		СтрокиКода.Добавить("");
		
	КонецЕсли;

	ВыводРезультатаВКоллекцию = (Настройки.ВыводРезультатаВ = ИТКВ_Перечисления.ВариантВыводаРезультатаСКДКоллекция());
	
	Если ВыводРезультатаВКоллекцию Тогда
		ТипГенератораМакетаКомпоновкиДанных = НСтр("ru = 'ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений';
													|en = 'DataCompositionValueCollectionTemplateGenerator'", Язык);
	Иначе
		ТипГенератораМакетаКомпоновкиДанных = НСтр("ru = 'ГенераторМакетаКомпоновкиДанных'; en = 'DataCompositionTemplateGenerator'", Язык);
	КонецЕсли;
	
	СтрокиКода.Добавить(НСтр("ru = 'КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;';
								|en = 'TemplateComposer = New DataCompositionTemplateComposer;'", Язык));
	Шаблон = НСтр("ru = 'МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
		                              |						КомпоновщикНастроек.Настройки, , ,
		                              |						Тип(""%1""));';
									  |en = 'CompositionTemplate = TemplateComposer.Execute(DataCompositionSchema,
		                              |						SettingsComposer.Settings, , ,
		                              |						Type(""%1""));'", Язык);
	СтрокиКода.Добавить(СтрШаблон(Шаблон, ТипГенератораМакетаКомпоновкиДанных));
	СтрокиКода.Добавить("");
	СтрокиКода.Добавить(НСтр("ru = 'ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;';
							|en = 'CompositionProcessor = New DataCompositionProcessor;'", Язык));
	
	Если ЗначениеЗаполнено(Данные.ВнешниеИсточники) Тогда
		ВнешниеИсточники = НСтр("ru = 'ВнешниеИсточники'; en = 'ExternalSources'", Язык);
	Иначе
		ВнешниеИсточники = Значение(Неопределено, ДополнительныеПараметры);
	КонецЕсли;
	
	Шаблон = НСтр("ru = 'ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, %1, , %2);'; en = 'CompositionProcessor.Initialize(CompositionTemplate, %1, , %2);'", Язык);
	СтрокиКода.Добавить(СтрШаблон(Шаблон, ВнешниеИсточники, Значение(Данные.ИспользованиеВнешнихФункций, ДополнительныеПараметры)));
	СтрокиКода.Добавить("");
	
	Если ВыводРезультатаВКоллекцию Тогда
		
		СтрокиКода.Добавить(НСтр("ru = 'ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;';
								|en = 'OutputProcessor = New DataCompositionResultValueCollectionOutputProcessor;'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'Результат = Новый ТаблицаЗначений;';
								|en = 'Result = New ValueTable;'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'ПроцессорВывода.УстановитьОбъект(Результат);';
								|en = 'OutputProcessor.SetObject(Result);'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'ПроцессорВывода.Вывести(ПроцессорКомпоновки);';
								|en = 'OutputProcessor.Output(CompositionProcessor);'", Язык));
		
	Иначе
		
		СтрокиКода.Добавить(НСтр("ru = 'ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;';
								|en = 'OutputProcessor = New DataCompositionResultSpreadsheetDocumentOutputProcessor;'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'Результат = Новый ТабличныйДокумент;';
								|en = 'Result = New SpreadsheetDocument;'", Язык));
		
		СтрокиКода.Добавить(НСтр("ru = 'ПроцессорВывода.УстановитьДокумент(Результат);';
								|en = 'OutputProcessor.SetDocument(Result);'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'ПроцессорВывода.Вывести(ПроцессорКомпоновки);';
								|en = 'OutputProcessor.Output(CompositionProcessor);'", Язык));
		СтрокиКода.Добавить(НСтр("ru = 'ДокументРезультат.Вывести(Результат);';
								|en = 'DocumentResult.Output(Result);'", Язык));
		
	КонецЕсли;
	
	Результат = СтрСоединить(СтрокиКода, Символы.ПС);
	
	Если Настройки.ИспользуетсяВОтчете Тогда
		
		Шаблон = НСтр("ru = 'Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
		|
		|	СтандартнаяОбработка = Ложь;
		|
		|	%1
		|
		|КонецПроцедуры'; en = 'Procedure OnComposeResult(DocumentResult, DecryptionData, StandardProcessing)
		|
		|	StandardProcessing = False;
		|
		|	%1
		|
		|EndProcedure'", Язык);
		Результат = СтрШаблон(Шаблон, ИТКВ_Строки.ДобавитьТабВМногострочныйТекст(Результат, Ложь));
		
	КонецЕсли;
	
	Возврат	Результат;
	
КонецФункции

// Получает код на встроенном языке для значения
//
// Параметры:
//  Значение  - Произвольный - Значение
//  ДополнительныеПараметры  - Структура - Переменная для возврата дополнения результата
//   * Язык - Строка - Код языка, по умолчанию русский
//   * ДобавлятьКомментарии - Булево - Добавлять комментарии, по умолчанию Ложь
//  ДополнениеРезультата  - Структура - Переменная для возврата дополнения результата
//   * ТребуетсяИнициализация - Булево - Требуется инициализация
//   * Комментарий - Строка - Комментарий
//	ВШаблоне - Булево - Используется в шаблоне (СтрШаблон)
//
// Возвращаемое значение:
//   Строка - код на встроенном языке для значения
//
Функция Значение(Значение, ДополнительныеПараметры = Неопределено, ДополнениеРезультата = Неопределено, ВШаблоне = Ложь) Экспорт
	
	// Инициализация
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.Свойство("Язык") Тогда
		ДополнительныеПараметры.Вставить("Язык", ИТКВ_ОбщийКлиентСервер.КодЯзыкаРусский());
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.Свойство("ДобавлятьКомментарии") Тогда
		ДополнительныеПараметры.Вставить("ДобавлятьКомментарии", Ложь);
	КонецЕсли;
	
	Язык = ДополнительныеПараметры.Язык;
	ТребуетсяИнициализация = Ложь;
	Комментарий = "";
	
	// Генерация кода для разных типов
	Если Значение = Неопределено Тогда
		
		Результат = НСтр("ru = 'Неопределено'; en = 'Undefined'", Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ТаблицаЗначений") Тогда
		
		ТребуетсяИнициализация = Истина;
		Результат = ЗначениеТаблицаЗначений(Значение, ДополнительныеПараметры);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("МоментВремени") Тогда
		
		Результат = ЗначениеМоментВремени(Значение, ДополнительныеПараметры);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Граница") Тогда
		
		Результат = ЗначениеГраница(Значение, ДополнительныеПараметры);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ВидГраницы") Тогда
		
		Результат = ЗначениеВидГраницы(Значение, Язык);
									
	ИначеЕсли ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
		
		ТребуетсяИнициализация = Истина;
		Результат = ЗначениеСписокЗначений(Значение, ДополнительныеПараметры);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ОписаниеТипов") Тогда
		
		Результат = ЗначениеОписаниеТипов(Значение, ДополнительныеПараметры);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("КвалификаторыЧисла") Тогда
		
		Шаблон = НСтр("ru = 'Новый КвалификаторыЧисла(%1, %2, %3)'; en = 'New NumberQualifiers(%1, %2, %3)'", Язык);
		Результат = СтрШаблон(Шаблон, Значение.Разрядность, Значение.РазрядностьДробнойЧасти, Значение(Значение.ДопустимыйЗнак, ДополнительныеПараметры));
		
	ИначеЕсли ТипЗнч(Значение) = Тип("КвалификаторыСтроки") Тогда
		
		Шаблон = НСтр("ru = 'Новый КвалификаторыСтроки(%1, %2)'; en = 'New StringQualifiers(%1, %2)'", Язык);
		Результат = СтрШаблон(Шаблон, Значение.Длина, Значение(Значение.ДопустимаяДлина, ДополнительныеПараметры));
		
	ИначеЕсли ТипЗнч(Значение) = Тип("КвалификаторыДаты") Тогда
		
		Шаблон = НСтр("ru = 'Новый КвалификаторыДаты(%1)'; en = 'New DateQualifiers(%1)'", Язык);
		Результат = СтрШаблон(Шаблон, Значение(Значение.ЧастиДаты, ДополнительныеПараметры));
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
		
		Результат = Формат(Значение, "ЧРД=.; ЧН=0; ЧГ=");
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		
		Результат = ИТКВ_КодКлиентСервер.ЗначениеСтрока(Значение);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Булево") Тогда
		
		Результат = ЗначениеБулево(Значение, Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("УникальныйИдентификатор") Тогда
		
		Шаблон = НСтр("ru = 'Новый УникальныйИдентификатор(""%1"")'; en = 'New UUID(""%1"")'", Язык);
		Результат = СтрШаблон(Шаблон, ВРег(Значение));
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Тип") Тогда
		
		Шаблон = НСтр("ru = 'Тип(""%1"")'; en = 'Type(""%1"")'", Язык);
		Результат = СтрШаблон(Шаблон, ИмяТипа(Значение, ДополнительныеПараметры));
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Дата") Тогда
		
		Результат = ЗначениеДата(Значение, Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ТипДополненияПериодамиСхемыЗапроса") Тогда
		
		Соответствие = Новый Соответствие;
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Год, НСтр("ru = 'ГОД'; en = 'YEAR'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Полугодие, НСтр("ru = 'ПОЛУГОДИЕ'; en = 'HALFYEAR'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Квартал, НСтр("ru = 'КВАРТАЛ'; en = 'QUARTER'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Месяц, НСтр("ru = 'МЕСЯЦ'; en = 'MONTH'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Декада, НСтр("ru = 'ДЕКАДА'; en = 'TENDAYS'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Неделя, НСтр("ru = 'НЕДЕЛЯ'; en = 'WEEK'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.День, НСтр("ru = 'ДЕНЬ'; en = 'DAY'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Час, НСтр("ru = 'ЧАС'; en = 'HOUR'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Минута, НСтр("ru = 'МИНУТА'; en = 'MINUTE'"));
		Соответствие.Вставить(ТипДополненияПериодамиСхемыЗапроса.Секунда, НСтр("ru = 'СЕКУНДА'; en = 'SECOND'"));
		
		Результат = Соответствие.Получить(Значение);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ВидДвиженияНакопления") Тогда
		
		Результат = ЗначениеВидДвиженияНакопления(Значение, Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ВидДвиженияБухгалтерии") Тогда
		
		Результат = ЗначениеВидДвиженияБухгалтерии(Значение, Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ВидСчета") Тогда
		
		Результат = ЗначениеВидСчета(Значение, Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ДопустимыйЗнак") Тогда
		
		Результат = ЗначениеДопустимыйЗнак(Значение, Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ДопустимаяДлина") Тогда
		
		Результат = ЗначениеДопустимаяДлина(Значение, Язык);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ЧастиДаты") Тогда
		
		Результат = ЗначениеЧастиДаты(Значение, Язык);
		
	Иначе
		
		Результат = ЗначениеПрочие(Значение, ДополнительныеПараметры, Комментарий);
		
	КонецЕсли;
	
	// Возврат результата
	ДополнениеРезультата = Новый Структура;
	ДополнениеРезультата.Вставить("ТребуетсяИнициализация", ТребуетсяИнициализация);
	ДополнениеРезультата.Вставить("Комментарий", Комментарий);
	
	Если ВШаблоне Тогда
		
		Результат = СтрЗаменить(Результат, "%", "%%");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Выполняет код на встроенном языке
//
// Параметры:
//
// Возвращаемое значение:
//
Функция Исполнить(Параметры, АдресРезультата) Экспорт
	
	Данные = Параметры.Данные;
	Режим = Параметры.Режим;
	
	Результат = ИТКВ_КодКлиентСервер.Исполнить(Данные.Текст, Режим);
	
	Сообщения = Новый ТаблицаЗначений;
	Сообщения.Колонки.Добавить("Текст", ИТКВ_ТипыКлиентСервер.ОписаниеСтрока());
	
	Для Каждого Сообщение Из ПолучитьСообщенияПользователю(Истина) Цикл
		
		НоваяСтрока = Сообщения.Добавить();
		НоваяСтрока.Текст = Сообщение.Текст;
		
	КонецЦикла;

	РезультатВыполнения = Результат.Результат;
	
	ПредставлениеРезультата = ИТКВ_КодКлиентСервер.СокращенноеПредставлениеРезультата(РезультатВыполнения);
	Результат.Вставить("Количество", СтрШаблон(НСтр("ru = '%1, сообщений: %2'; en = '%1, posts: %2'"), ПредставлениеРезультата, Сообщения.Количество()));
	
	// Подготовка результата
	ОписаниеРезультата = Новый Структура;
	ОписаниеРезультата.Вставить("Результат", РезультатВыполнения);
	ОписаниеРезультата.Вставить("Сообщения", Сообщения);
	
	Результат.Вставить("Результат", ОписаниеРезультата);

	ИТКВ_ВременноеХранилище.Поместить(Результат, АдресРезультата);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает имя типа
//
// Параметры:
//  Тип  - Тип - Тип
//  Язык  - Строка - Язык
//
// Возвращаемое значение:
//   Строка - Имя типа на встроенном языке
//
Функция ИмяТипа(Тип, ДополнительныеПараметры)
	
	Язык = ДополнительныеПараметры.Язык;
	
	Если Тип = Тип("Число") Тогда
		
		Результат = НСтр("ru = 'Число'; en = 'Number'", Язык);
		
	ИначеЕсли Тип = Тип("Булево") Тогда
		
		Результат = НСтр("ru = 'Булево'; en = 'Boolean'", Язык);
		
	ИначеЕсли Тип = Тип("Дата") Тогда
		
		Результат = НСтр("ru = 'Дата'; en = 'Date'", Язык);
		
	ИначеЕсли Тип = Тип("Строка") Тогда
		
		Результат = НСтр("ru = 'Строка'; en = 'String'", Язык);
		
	ИначеЕсли Тип = Тип("УникальныйИдентификатор") Тогда
		
		Результат = НСтр("ru = 'УникальныйИдентификатор'; en = 'UUID'", Язык);
		
	ИначеЕсли Тип = Тип("ХранилищеЗначения") Тогда
		
		Результат = НСтр("ru = 'ХранилищеЗначения'; en = 'ValueStorage'", Язык);
		
	Иначе
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		
		Если ОбъектМетаданных = Неопределено Тогда
			
			Результат = Значение(Неопределено, ДополнительныеПараметры);
			
		Иначе
			
			ИмяОбъектаКоллекции = ИТКВ_Метаданные.ИмяОбъектаКоллекции(ОбъектМетаданных);
			Результат = ИТКВ_МетаданныеКлиентСервер.ТипСсылка(ИмяОбъектаКоллекции, ОбъектМетаданных.Имя, Язык);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СписокИменТипов(Типы, ДополнительныеПараметры)
	
	Результат = Новый Массив;
	Для Каждого Тип Из Типы Цикл
		
		Результат.Добавить(ИмяТипа(Тип, ДополнительныеПараметры));
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеВидДвиженияНакопления(Значение, Язык)
	
	Если Значение = ВидДвиженияНакопления.Приход Тогда
		
		Вид = НСтр("ru = 'Приход'; en = 'Receipt'", Язык);
		
	Иначе
		
		Вид = НСтр("ru = 'Расход'; en = 'Expense'", Язык);
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1.%2", ИТКВ_КодКлиентСервер.ИмяОбъектаВидДвиженияНакопления(Язык), Вид);
	
КонецФункции

Функция ЗначениеВидДвиженияБухгалтерии(Значение, Язык)
	
	Если Значение = ВидДвиженияБухгалтерии.Дебет Тогда
		
		Вид = НСтр("ru = 'Дебет'; en = 'Debit'", Язык);
		
	Иначе
		
		Вид = НСтр("ru = 'Кредит'; en = 'Credit'", Язык);
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1.%2", ИТКВ_КодКлиентСервер.ИмяОбъектаВидДвиженияБухгалтерии(Язык), Вид);
	
КонецФункции

Функция ЗначениеВидСчета(Значение, Язык)
	
	Если Значение = ВидСчета.Активный Тогда
		
		Вид = НСтр("ru = 'Активный'; en = 'Active'", Язык);
		
	ИначеЕсли Значение = ВидСчета.Пассивный Тогда
		
		Вид = НСтр("ru = 'Пассивный'; en = 'Passive'", Язык);
		
	Иначе
		
		Вид = НСтр("ru = 'АктивноПассивный'; en = 'ActivePassive'", Язык);
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1.%2", ИТКВ_КодКлиентСервер.ИмяОбъектаВидСчета(Язык), Вид);
	
КонецФункции

Функция ЗначениеМоментВремени(Значение, ДополнительныеПараметры)
	
	Параметры = Новый Массив;
	Параметры.Добавить(Значение(Значение.Дата, ДополнительныеПараметры));
	
	Если ЗначениеЗаполнено(Значение.Ссылка) Тогда
		
		Параметры.Добавить(Значение(Значение.Ссылка, ДополнительныеПараметры));
		
	КонецЕсли;
	
	Шаблон = НСтр("ru = 'Новый МоментВремени(%1)'; en = 'New PointInTime(%1)'", ДополнительныеПараметры.Язык);
	Возврат СтрШаблон(Шаблон, СтрСоединить(Параметры, ", "));
	
КонецФункции

Функция ЗначениеГраница(Значение, ДополнительныеПараметры)
	
	Шаблон = НСтр("ru = 'Новый Граница(%1, %2)'; en = 'New Boundary(%1, %2)'", ДополнительныеПараметры.Язык);
	Возврат СтрШаблон(Шаблон, Значение(Значение.Значение, ДополнительныеПараметры), Значение(Значение.ВидГраницы, ДополнительныеПараметры));
	
КонецФункции

Функция ЗначениеВидГраницы(Значение, Язык)
	
	Если Значение = ВидГраницы.Включая Тогда
		
		Вид = НСтр("ru = 'Включая'; en = 'Including'", Язык);
		
	Иначе
		
		Вид = НСтр("ru = 'Исключая'; en = 'Excluding'", Язык);
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1.%2", ИТКВ_КодКлиентСервер.ИмяОбъектаВидГраницы(Язык), Вид);
	
КонецФункции

Функция ЗначениеДопустимыйЗнак(Значение, Язык)
	
	Если Значение = ДопустимыйЗнак.Любой Тогда
		
		Вид = НСтр("ru = 'Любой'; en = 'Any'", Язык);
		
	Иначе
		
		Вид = НСтр("ru = 'Неотрицательный'; en = 'Nonnegative'", Язык);
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1.%2", ИТКВ_КодКлиентСервер.ИмяОбъектаДопустимыйЗнак(Язык), Вид);
	
КонецФункции

Функция ЗначениеДопустимаяДлина(Значение, Язык)
	
	Если Значение = ДопустимаяДлина.Переменная Тогда
		
		Вид = НСтр("ru = 'Переменная'; en = 'Variable'", Язык);
		
	Иначе
		
		Вид = НСтр("ru = 'Фиксированная'; en = 'Fixed'", Язык);
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1.%2", ИТКВ_КодКлиентСервер.ИмяОбъектаДопустимаяДлина(Язык), Вид);
	
КонецФункции

Функция ЗначениеЧастиДаты(Значение, Язык)
	
	Если Значение = ЧастиДаты.Время Тогда
		
		Вид = НСтр("ru = 'Время'; en = 'Time'", Язык);
		
	ИначеЕсли Значение = ЧастиДаты.Дата Тогда
		
		Вид = НСтр("ru = 'Дата'; en = 'Date'", Язык);
		
	Иначе
		
		Вид = НСтр("ru = 'ДатаВремя'; en = 'DateTime'", Язык);
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1.%2", ИТКВ_КодКлиентСервер.ИмяОбъектаЧастиДаты(Язык), Вид);
	
КонецФункции

Функция ЗначениеДата(Значение, Язык)
	
	Параметры = Новый Массив;
	
	Год = ИТКВ_Строки.ЧислоВСтроку(Год(Значение));
	Параметры.Добавить(Год);
	Параметры.Добавить(Месяц(Значение));
	Параметры.Добавить(День(Значение));
	
	Час = Час(Значение);
	Минута = Минута(Значение);
	Секунда = Секунда(Значение);
	
	Если ЗначениеЗаполнено(Час)
			ИЛИ ЗначениеЗаполнено(Минута)
			ИЛИ ЗначениеЗаполнено(Секунда) Тогда
			
		Параметры.Добавить(Час);
		Параметры.Добавить(Минута);
		Параметры.Добавить(Секунда);
		
	КонецЕсли;
	
	Шаблон = НСтр("ru = 'Дата(%1)'; en = 'Date(%1)'", Язык);
	Возврат СтрШаблон(Шаблон, СтрСоединить(Параметры, ", "));
	
КонецФункции

Функция ЗначениеБулево(Значение, Язык)
	
	Если Значение Тогда
		
		Результат = НСтр("ru = 'Истина'; en = 'True'", Язык);
		
	Иначе
		
		Результат = НСтр("ru = 'Ложь'; en = 'False'", Язык);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеСписокЗначений(Значение, ДополнительныеПараметры)
	
	Результат = Новый Массив;
	Результат.Добавить(НСтр("ru = '%1 = Новый СписокЗначений;'; en = '%1 = New ValueList;'", ДополнительныеПараметры.Язык));
	
	Для Каждого ЭлементСписка Из Значение Цикл
		
		ДополнениеРезультата = Неопределено;
		КодЗначенияЭлемента = Значение(ЭлементСписка.Значение, ДополнительныеПараметры, ДополнениеРезультата);
		
		Если ДополнительныеПараметры.ДобавлятьКомментарии И ЗначениеЗаполнено(ДополнениеРезультата.Комментарий) Тогда
			
			Комментарий = СтрШаблон("// %1", ДополнениеРезультата.Комментарий);
			
		Иначе
			
			Комментарий = "";
			
		КонецЕсли;
		
		Шаблон = НСтр("ru = 'Добавить(%1);%2'; en = 'Add(%1);%2'", ДополнительныеПараметры.Язык);
		Результат.Добавить("%1." + СтрШаблон(Шаблон, КодЗначенияЭлемента, Комментарий));
		
	КонецЦикла;
	
	Возврат СтрСоединить(Результат, Символы.ПС);
	
КонецФункции

Функция ЗначениеОписаниеТипов(Значение, ДополнительныеПараметры)
	
	Язык = ДополнительныеПараметры.Язык;
	
	КвалификаторыЧисла = "";
	Если Значение.СодержитТип(Тип("Число")) Тогда
		КвалификаторыЧисла = Значение(Значение.КвалификаторыЧисла, ДополнительныеПараметры);
	КонецЕсли;
	
	КвалификаторыСтроки = "";
	Если Значение.СодержитТип(Тип("Строка")) Тогда
		КвалификаторыСтроки = Значение(Значение.КвалификаторыСтроки, ДополнительныеПараметры);
	КонецЕсли;
	
	КвалификаторыДаты = "";
	Если Значение.СодержитТип(Тип("Дата")) Тогда
		КвалификаторыДаты = Значение(Значение.КвалификаторыДаты, ДополнительныеПараметры);
	КонецЕсли;
	
	СписокТипов = СтрСоединить(СписокИменТипов(Значение.Типы(), ДополнительныеПараметры), ",");
	
	Шаблон = НСтр("ru = 'Новый ОписаниеТипов(""%1"", %2, %3, %4)'; en = 'New TypeDescription(""%1"", %2, %3, %4)'", Язык);
	Возврат СтрШаблон(Шаблон, СписокТипов, КвалификаторыЧисла, КвалификаторыСтроки, КвалификаторыДаты);
	
КонецФункции

Функция ЗначениеТаблицаЗначений(Значение, ДополнительныеПараметры)
	
	Язык = ДополнительныеПараметры.Язык;
	ДобавлятьКомментарии = ДополнительныеПараметры.ДобавлятьКомментарии;
	
	Результат = Новый Массив;
	Результат.Добавить(НСтр("ru = '%1 = Новый ТаблицаЗначений;'; en = '%1 = New ValueTable;'", Язык));
	
	// Добавляем код колонок
	Колонки = Значение.Колонки;
	Если ЗначениеЗаполнено(Колонки) Тогда
		
		Результат.Добавить("");
		
		Если ДобавлятьКомментарии Тогда
			
			Результат.Добавить(НСтр("ru = '// Добавляем колонки'; en = '// Add columns'", Язык));
			
		КонецЕсли;
		
		Для Каждого Колонка Из Колонки Цикл
			
			Шаблон = НСтр("ru = 'Колонки.Добавить(%1, %2);'; en = 'Columns.Add(%1, %2);'", Язык);
			КодДобавлениеКолонки = СтрШаблон(Шаблон, Значение(Колонка.Имя), Значение(Колонка.ТипЗначения, ДополнительныеПараметры));
			Результат.Добавить("%1." + КодДобавлениеКолонки);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Индексы колонок
	Индексы = Значение.Индексы;
	Если ЗначениеЗаполнено(Индексы) Тогда
		
		Если ДобавлятьКомментарии Тогда
			
			Результат.Добавить(НСтр("ru = '// Добавляем индексы'; en = '// Add indexes'", Язык));
			
		КонецЕсли;
		
		Для Каждого Индекс Из Индексы Цикл
			
			Шаблон = НСтр("ru = 'Индексы.Добавить(%1);'; en = 'Indexes.Add(%1);'", Язык);
			КодДобавленияИндекса = СтрШаблон(Шаблон, Значение(Строка(Индекс)));
			Результат.Добавить("%1." + КодДобавленияИндекса);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Добавляем код строк
	Если ЗначениеЗаполнено(Значение) Тогда

		Результат.Добавить("");
		
		Если ДобавлятьКомментарии Тогда
			
			Результат.Добавить(НСтр("ru = '// Добавляем строки'; en = '// Add rows'", Язык));
			
		КонецЕсли;
		
		Для Каждого СтрокаТЗ Из Значение Цикл
			
			Результат.Добавить(НСтр("ru = 'НоваяСтрока = %1.Добавить();'; en = 'NewRow = %1.Add();'", Язык));
			
			Для Каждого Колонка Из Колонки Цикл
				
				Шаблон = НСтр("ru = 'НоваяСтрока[""%1""] = %2;'; en = 'NewRow[""%1""] = %2;'", Язык);
				Результат.Добавить(СтрШаблон(Шаблон, Колонка.Имя, Значение(СтрокаТЗ[Колонка.Имя], ДополнительныеПараметры, , Истина)));
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтрСоединить(Результат, Символы.ПС);
	
КонецФункции

Функция ЗначениеПрочие(Значение, ДополнительныеПараметры, Комментарий)
	
	ТипЗначения = ТипЗнч(Значение);
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗначения);
	
	Если ОбъектМетаданных = Неопределено Тогда
		
		Результат = Значение(Неопределено, ДополнительныеПараметры);
		
	Иначе
		
		Результат = ЗначениеСсылка(Значение, ДополнительныеПараметры, Комментарий);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеСсылка(Значение, ДополнительныеПараметры, Комментарий)
	
	Язык = ДополнительныеПараметры.Язык;
	
	ТипЗначения = ТипЗнч(Значение);
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗначения);
	ИмяОбъектаМетаданных = ОбъектМетаданных.Имя;
	
	ПолноеИмяМетаданных = ИТКВ_Метаданные.ПолноеИмя(ОбъектМетаданных, Язык);
	ИмяКоллекцииМетаданных = ИТКВ_Метаданные.ИмяКоллекции(ОбъектМетаданных, Язык);
	ИмяОбъектаКоллекции = ИТКВ_Метаданные.ИмяОбъектаКоллекции(ОбъектМетаданных, Язык);
	
	Если ИТКВ_Метаданные.ЭтоТипТочкаМаршрутаБизнесПроцесса(ТипЗначения) Тогда
		
		ИмяТочки = "";
		ТочкиМаршрута = БизнесПроцессы[ИмяОбъектаМетаданных].ТочкиМаршрута;
		Для Каждого ТочкаМаршрута Из ТочкиМаршрута Цикл
			
			Если ТочкаМаршрута = Значение Тогда
				
				ИмяТочки = ТочкаМаршрута.Имя;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Результат = СтрШаблон("БизнесПроцессы.%1.ТочкиМаршрута.%2", ИмяОбъектаМетаданных, ИмяТочки);
		
	ИначеЕсли Значение.Пустая() Тогда
		
		Шаблон = НСтр("ru = '%1.%2.ПустаяСсылка()'; en = '%1.%2.EmptyRef()'", Язык);
		Результат = СтрШаблон(Шаблон, ИмяКоллекцииМетаданных, ИмяОбъектаМетаданных);
		
	ИначеЕсли ИТКВ_МетаданныеКлиентСерверПовтИсп.ЭтоПеречисление(ИмяОбъектаКоллекции) Тогда
		
		Результат = СтрШаблон("%1.%2.%3", ИмяКоллекцииМетаданных, ИмяОбъектаМетаданных, XMLСтрока(Значение));
		
	Иначе
		
		Если ИТКВ_МетаданныеКлиентСерверПовтИсп.ОбъектCПредопределенными(ИмяОбъектаКоллекции)
				И Значение.Предопределенный Тогда
			
			Результат = СтрШаблон("%1.%2.%3", ИмяКоллекцииМетаданных, ИмяОбъектаМетаданных, Значение.ИмяПредопределенныхДанных);
			
		Иначе
			
			Шаблон = НСтр("ru = '%1.%2.ПолучитьСсылку(%3)'; en = '%1.%2.GetRef(%3)'", Язык);
			Результат = СтрШаблон(Шаблон, ИмяКоллекцииМетаданных, ИмяОбъектаМетаданных, Значение(Значение.УникальныйИдентификатор(), ДополнительныеПараметры));
			Комментарий = СтрШаблон("%1 (%2.%3)", Строка(Значение), ИмяКоллекцииМетаданных, ИмяОбъектаМетаданных);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ГенерироватьКодУстановкиПараметров(Данные, Строки, ДополнительныеПараметры)
	
	Язык = ДополнительныеПараметры.Язык;
	ДобавлятьКомментарии = ДополнительныеПараметры.ДобавлятьКомментарии;
	
	ЗначенияПараметров = ИТКВ_Запрос.ЗначенияПараметров(Данные, Ложь);
	Если Не ЗначениеЗаполнено(ЗначенияПараметров) Тогда
		Возврат;
	КонецЕсли;
	
	Строки.Добавить("");
	Если ДобавлятьКомментарии Тогда
		
		Строки.Добавить(НСтр("ru = '// Установка значений параметров'; en = '// Setting parameter values'", Язык));
		
	КонецЕсли;
	
	Для Каждого ОписаниеПараметра Из ЗначенияПараметров Цикл
		
		ИмяПараметра = ОписаниеПараметра.Ключ;
		ЗначениеПараметра = ОписаниеПараметра.Значение;
		
		СложныйПараметр = Ложь;
		ВидПараметра = "";
		КодИнициализацииПараметра = "";
		КомментарийПараметра = "";
		
		Если ТипЗнч(ЗначениеПараметра) = Тип("Структура") И ЗначениеПараметра.Вид = ИТКВ_Перечисления.СложныйПараметрЗапросаВыражение() Тогда
			
			СложныйПараметр = Истина;
			ВидПараметра = НСтр("ru = 'Выражение'; en = 'Expression'");
			КодИнициализацииПараметра = ЗначениеПараметра.Значение;
			КодЗначенияПараметра = ИТКВ_РедакторКодаКлиентСервер.ИмяПеременнойВозвратаРезультата(Язык);
			
		Иначе
			
			Если ТипЗнч(ЗначениеПараметра) = Тип("Структура") Тогда
				
				Если ЗначениеПараметра.Вид = ИТКВ_Перечисления.СложныйПараметрЗапросаТаблицаЗначений() Тогда
					
					СложныйПараметр = Истина;
					ВидПараметра = НСтр("ru = 'Таблица значений'; en = 'Table of values'");
					ЗначениеПараметра = ПолучитьИзВременногоХранилища(ЗначениеПараметра.Значение);
					
				ИначеЕсли ЗначениеПараметра.Вид = ИТКВ_Перечисления.СложныйПараметрЗапросаГраница() Тогда
					
					ОписаниеГраницы = ЗначениеПараметра.Значение;
					ЗначениеПараметра = ИТКВ_Запрос.ГраницаИзОписания(ОписаниеГраницы);
					
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(ЗначениеПараметра) = Тип("СписокЗначений") Тогда
				
				СложныйПараметр = Истина;
				ВидПараметра = НСтр("ru = 'Список значений'; en = 'List of values'");
				
			КонецЕсли;
			
			ДополнениеРезультата = Неопределено;
			КодЗначенияПараметра = Значение(ЗначениеПараметра, ДополнительныеПараметры, ДополнениеРезультата);
			
			Если ЗначениеЗаполнено(ДополнениеРезультата.Комментарий) Тогда
				КомментарийПараметра = ДополнениеРезультата.Комментарий;
			КонецЕсли;
			
			Если ДополнениеРезультата.ТребуетсяИнициализация Тогда
				КодИнициализацииПараметра = СтрШаблон(КодЗначенияПараметра, НСтр("ru = 'Параметр'; en = 'Parametr'", Язык));
			КонецЕсли;
			
		КонецЕсли;
		
		Если СложныйПараметр Тогда
			
			КодЗначенияПараметра = НСтр("ru = 'Параметр'; en = 'Parametr'", Язык);
			
			Если ДобавлятьКомментарии Тогда
				Строки.Добавить(СтрШаблон(НСтр("ru = '// Параметр ""%1"" (%2)'; en = '// Parametr ""%1"" (%2)'", Язык), ИмяПараметра, ВидПараметра));
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КодИнициализацииПараметра) Тогда
			Строки.Добавить(КодИнициализацииПараметра);
		КонецЕсли;
		
		// Строка установки значения параметра
		Шаблон = НСтр("ru = 'Запрос.УстановитьПараметр(""%1"", %2);'; en = 'Query.SetParameter(""%1"", %2);'", Язык);
		КодУстановкиЗначенияПараметра = СтрШаблон(Шаблон, ИмяПараметра, КодЗначенияПараметра);
		
		Если ЗначениеЗаполнено(КомментарийПараметра) Тогда
			КодУстановкиЗначенияПараметра = КодУстановкиЗначенияПараметра + "// " + КомментарийПараметра;
		КонецЕсли;
		
		Строки.Добавить(КодУстановкиЗначенияПараметра);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ГенерироватьКодДобавитьТекстВСтроки(Текст, Строки)
	
	Для НомерСтроки = 1 По СтрЧислоСтрок(Текст) Цикл
		
		Строка = СтрПолучитьСтроку(Текст, НомерСтроки);
		Строки.Добавить(Строка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ГенерироватьКодВыборкиЗапроса(СхемаЗапроса, Строки, Настройки, Язык)
	
	Строки.Добавить("");
	
	Если Настройки.ДобавлятьКомментарии Тогда
		Строки.Добавить(НСтр("ru = '// Выборка'; en = '// Selection'"));
	КонецЕсли;
	
	ИмяНачальнойВыборки = НСтр("ru = 'Результат'; en = 'Result'");
	
	Если Настройки.ВыборкаПоГруппировкам Тогда
		
		ЗапросСхемы = ИТКВ_Запрос.ПервыйЗапросСхемыСРезультатом(СхемаЗапроса);
		
		Если ЗапросСхемы.ОбщиеИтоги Тогда
			
			Строки.Добавить(НСтр("ru = 'ВыборкаОбщийИтог = Результат.Выбрать();'; en = 'SelectionCommon = Result.Select();'", Язык));
			Строки.Добавить(НСтр("ru = 'ВыборкаОбщийИтог.Следующий();'; en = 'SelectionCommon.Next();'", Язык));
			Строки.Добавить("");
			
			ИмяНачальнойВыборки = НСтр("ru = 'ВыборкаОбщийИтог'; en = 'SelectionCommon'");
			
		КонецЕсли;
		
		ШаблонВыборки = "";
		
		ТекстКод = НСтр("ru = '// Код'; en = '// Code'", Язык);
		ИмяВыборки = ИмяНачальнойВыборки;
		Для Каждого ЭлементИтог Из ЗапросСхемы.КонтрольныеТочкиИтогов Цикл
			
			Если ЭлементИтог.ТипКонтрольнойТочки = ТипКонтрольнойТочкиСхемыЗапроса.Элементы Тогда
				ТипВыборки = НСтр("ru = 'ОбходРезультатаЗапроса.ПоГруппировкам'; en = 'QueryResultIteration.ByGroups'");
			Иначе
				ТипВыборки = НСтр("ru = 'ОбходРезультатаЗапроса.ПоГруппировкамСИерархией'; en = 'QueryResultIteration.ByGroupsWithHierarchy'");
			КонецЕсли;
			
			ШаблонИмени = НСтр("ru = 'Выборка%1'; en = 'Selection%1'", Язык);
			ИмяНовойВыборки = СтрШаблон(ШаблонИмени, ЭлементИтог.ИмяКолонки);
			Шаблон = КодШаблонаЭлементаВыборкиЗапроса(ИмяНовойВыборки, ИмяВыборки, Язык, ТипВыборки);
			ИмяВыборки = ИмяНовойВыборки;
			Если ЗначениеЗаполнено(ШаблонВыборки) Тогда
				ШаблонВыборки = СтрШаблон(ШаблонВыборки, ИТКВ_Строки.ДобавитьТабВМногострочныйТекст(Шаблон, Ложь));
			Иначе
				ШаблонВыборки = Шаблон;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		ШаблонВыборки = КодШаблонаЭлементаВыборкиЗапроса(НСтр("ru = 'Выборка'; en = 'Selection'", Язык), ИмяНачальнойВыборки, Язык);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонВыборки) Тогда
		
		ТекстВыборки = СтрШаблон(ШаблонВыборки, НСтр("ru = '// Код'; en = '// Code'", Язык));
		ГенерироватьКодДобавитьТекстВСтроки(ТекстВыборки, Строки)
		
	КонецЕсли;
		
КонецПроцедуры

Функция КодШаблонаЭлементаВыборкиЗапроса(Имя, ИмяНачала, Язык, Тип = "")
	
	Шаблон = НСтр("ru = '%1 = %2.Выбрать(%3);
	|Пока %1.Следующий() Цикл
	|	%%1
	|КонецЦикла;';
	|en = '%1 = %2.Select(%3);
	|While %1.Next() Do
	|	%%1
	|EndDo;'", Язык);
	
	Возврат СтрШаблон(Шаблон, Имя, ИмяНачала, Тип);
	
КонецФункции

#КонецОбласти
