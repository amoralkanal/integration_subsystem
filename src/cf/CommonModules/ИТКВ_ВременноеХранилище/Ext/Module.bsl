﻿#Область ПрограммныйИнтерфейс

// Удаляет данные из временного хранилища
//
// Параметры:
//	Данные - Строка, Массив - Адрес во временном хранилище или массив адресов
//
Процедура Удалить(Данные) Экспорт
	
	Если ТипЗнч(Данные) = Тип("Массив") Тогда
		
		Для Каждого АдресДанных Из Данные Цикл
			
			Удалить(АдресДанных);
			
		КонецЦикла;
		
	Иначе
		
		Если ЭтоАдресВременногоХранилища(Данные) Тогда
			УдалитьАдресИзВременногоХранилища(Данные);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Создает пустое временное хранилище
//
// Параметры:
//  АдресУникальныйИдентификатор  - Строка, УникальныйИдентификатор - Адрес, уникальный идентификатор
//
// Возвращаемое значение:
//   Строка - Адрес во временном хранилище
//
Функция Пустое(АдресУникальныйИдентификатор = Неопределено) Экспорт
	
	Возврат ПоместитьВоВременноеХранилище(Неопределено, АдресУникальныйИдентификатор);
	
КонецФункции

// Помещает значение во временное хранилище
//
// Параметры:
//  Значение  - Произвольный - Произвольное значение
//  Адрес  - Строка - Адрес во временном хранилище
//  УникальныйИдентификатор  - УникальныйИдентификатор - Уникальный идентификатор
//
// Возвращаемое значение:
//   Строка - Адрес во временном хранилище
//
Функция Поместить(Значение, Адрес = Неопределено, УникальныйИдентификатор = Неопределено) Экспорт
	
	Если ЭтоАдресВременногоХранилища(Адрес) Тогда
		ИсточникАдреса = Адрес;
	ИначеЕсли ЗначениеЗаполнено(УникальныйИдентификатор) Тогда
		ИсточникАдреса = УникальныйИдентификатор;
	Иначе
		ИсточникАдреса = Неопределено
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(Значение, ИсточникАдреса);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УдалитьАдресИзВременногоХранилища(Адрес)
	
	Результат = Ложь;
	Если ЭтоАдресВременногоХранилища(Адрес) Тогда
		Результат = Истина;
		УдалитьИзВременногоХранилища(Адрес);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
