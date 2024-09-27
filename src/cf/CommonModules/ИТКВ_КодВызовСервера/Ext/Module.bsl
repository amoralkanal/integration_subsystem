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
	
	Возврат	ИТКВ_Код.Запрос(Данные, Настройки);
	
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
	
	Возврат	ИТКВ_Код.СхемаКомпоновкиДанных(Данные, Настройки);
	
КонецФункции

// Получает код для запроса
//
// Параметры:
//  Адрес  - Строка - Адрес во временном хранилище
//  Имя  - Строка - Имя
//
// Возвращаемое значение:
//   Строка - код на встроенном языке для таблицы значений
//
Функция ТаблицаЗначений(Адрес, Имя) Экспорт

	Если ЭтоАдресВременногоХранилища(Адрес) Тогда
		ТаблицаЗначений = ПолучитьИзВременногоХранилища(Адрес);
		УдалитьИзВременногоХранилища(Адрес);
	Иначе
		ТаблицаЗначений = Новый ТаблицаЗначений;
	КонецЕсли;
	
	ДополнениеРезультата = Неопределено;
	КодНаВстроенномЯзыке = ИТКВ_Код.Значение(ТаблицаЗначений, , ДополнениеРезультата);
	Идентификатор = ИТКВ_РедакторКодаКлиентСервер.ИмяПеременнойВозвратаРезультата(ИТКВ_Общий.КодЯзыкаПрограммирования());
	
	Если ДополнениеРезультата.ТребуетсяИнициализация Тогда
		КодНаВстроенномЯзыке = СтрШаблон(КодНаВстроенномЯзыке + "
		|%2 = %1;", Имя, Идентификатор);
	Иначе
		КодНаВстроенномЯзыке = СтрШаблон("%2 = %1;", КодНаВстроенномЯзыке, Идентификатор);
	КонецЕсли;
			
	Возврат КодНаВстроенномЯзыке;

КонецФункции

// Получает значение параметра
//
// Параметры:
//  Значение  - Произвольный - Значение параметра
//  Имя  - Строка - Имя
//
// Возвращаемое значение:
//   Строка - код на встроенном языке для значения параметра
//
Функция ЗначениеПараметра(Значение, Имя = Неопределено) Экспорт

	Если ЭтоАдресВременногоХранилища(Значение) Тогда
		
		ЗначениеПараметра = ПолучитьИзВременногоХранилища(Значение);
		УдалитьИзВременногоХранилища(Значение);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("Структура") Тогда // Граница
		
		ЗначениеПараметра = ИТКВ_Запрос.ГраницаИзОписания(Значение);
		
	Иначе
		
		ЗначениеПараметра = Значение;
		
	КонецЕсли;
	
	ДополнениеРезультата = Неопределено;

	КодНаВстроенномЯзыке = ИТКВ_Код.Значение(ЗначениеПараметра, , ДополнениеРезультата);
	Идентификатор = ИТКВ_РедакторКодаКлиентСервер.ИмяПеременнойВозвратаРезультата(ИТКВ_Общий.КодЯзыкаПрограммирования());
	
	Если ДополнениеРезультата.ТребуетсяИнициализация Тогда
		
		КодНаВстроенномЯзыке = СтрШаблон(КодНаВстроенномЯзыке + "
									|%2 = %1;", Имя, Идентификатор);
	Иначе
		КодНаВстроенномЯзыке = СтрШаблон("%2 = %1;", КодНаВстроенномЯзыке, Идентификатор);
	КонецЕсли;
			
	Возврат ИТКВ_ЗапросКлиентСервер.ЗначениеСложногоПараметра(ИТКВ_Перечисления.СложныйПараметрЗапросаВыражение(), КодНаВстроенномЯзыке);

КонецФункции

// Таблица значений из выражения на встроенном языке
//
// Параметры:
//  Алгоритм  - Строка - Алгоритм
//  УникальныйИдентификатор  - УникальныйИдентификатор - Уникальный идентификатор
//
// Возвращаемое значение:
//   Строка - Адрес таблицы значений во временном хранилище
//
Функция ТаблицаЗначенийИзВыражения(Алгоритм, УникальныйИдентификатор) Экспорт
	
	Результат = Неопределено;
	
	Попытка
		
		Результат = ИТКВ_Общий.ВычислитьРезультатВыражениеВБезопасномРежиме(Алгоритм);
		
	Исключение
		
		НеБудемОбрабатыватьИсключение = Истина;
		
	КонецПопытки;
	
	Если ТипЗнч(Результат) <> Тип("ТаблицаЗначений") Тогда
		Результат = Новый ТаблицаЗначений;
	КонецЕсли;
	
	Возврат ИТКВ_ВременноеХранилище.Поместить(Результат, , УникальныйИдентификатор);
	
КонецФункции

// Параметр из выражения на встроенном языке
//
// Параметры:
//  Алгоритм  - Строка - Алгоритм
//  УникальныйИдентификатор  - УникальныйИдентификатор - Уникальный идентификатор
//
// Возвращаемое значение:
//   Произвольный - Значений параметра
//
Функция ПараметрИзВыражения(Алгоритм, УникальныйИдентификатор, ТекстОшибки = "") Экспорт
	
	Результат = Неопределено;
	
	Попытка
		
		Результат = ИТКВ_Общий.ВычислитьРезультатВыражениеВБезопасномРежиме(Алгоритм);
		
	Исключение
		
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Если ТипЗнч(Результат) = Тип("ТаблицаЗначений") Тогда
		
		АдресЗначения = ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
		Результат = ИТКВ_ЗапросКлиентСервер.ЗначениеСложногоПараметра(ИТКВ_Перечисления.СложныйПараметрЗапросаТаблицаЗначений(), АдресЗначения);
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Получает код на встроенном языке для значения
//
// Параметры:
//  Значение  - Произвольный - Произвольное значений
//
// Возвращаемое значение:
//   Строка - Код на встроенном языке для значения
//
Функция Значение(Значение) Экспорт
	
	Возврат ИТКВ_Код.Значение(Значение);
	
КонецФункции

#КонецОбласти
