﻿//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановитьКонтекстИсполнения(ТестовыйМодуль = Неопределено, Набор = Неопределено, Тест = Неопределено) Экспорт
	
	Уровни = ЮТФабрика.УровниИсполнения();
	КонтекстИсполнения = ЮТКонтекстСлужебный.КонтекстИсполнения();
	
	КонтекстИсполнения.Модуль = ТестовыйМодуль;
	КонтекстИсполнения.Набор = Набор;
	КонтекстИсполнения.Тест = Тест;
	
	Если Тест <> Неопределено Тогда
		КонтекстИсполнения.Уровень = Уровни.Тест;
	ИначеЕсли Набор <> Неопределено Тогда
		КонтекстИсполнения.Уровень = Уровни.НаборТестов;
	ИначеЕсли ТестовыйМодуль <> Неопределено Тогда
		КонтекстИсполнения.Уровень = Уровни.Модуль;
	Иначе
		КонтекстИсполнения.Уровень = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "ИнициализацияКонтекста"
// 
// Параметры:
//  ДанныеКонтекста - Структура
Процедура ИнициализацияКонтекста(ДанныеКонтекста) Экспорт
	
	ДанныеКонтекста.Вставить(ЮТКонтекстСлужебный.ИмяКонтекстаИсполнения(), ЮТФабрикаСлужебный.НовыйКонтекстИсполнения());
	
КонецПроцедуры

Процедура ПередВсемиТестами(ОписаниеСобытия) Экспорт
	
	УстановитьКонтекстИсполнения(ОписаниеСобытия.Модуль);
	ЮТКонтекстСлужебный.УстановитьКонтекстМодуля();
	
КонецПроцедуры

Процедура ПередТестовымНабором(ОписаниеСобытия) Экспорт
	
	УстановитьКонтекстИсполнения(ОписаниеСобытия.Модуль, ОписаниеСобытия.Набор);
	ЮТКонтекстСлужебный.УстановитьКонтекстНабораТестов();
	
КонецПроцедуры

Процедура ПередКаждымТестом(ОписаниеСобытия) Экспорт
	
#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	ПолучитьСообщенияПользователю(Истина);
#КонецЕсли
	
	УстановитьКонтекстИсполнения(ОписаниеСобытия.Модуль, ОписаниеСобытия.Набор, ОписаниеСобытия.Тест);
	ЮТКонтекстСлужебный.УстановитьКонтекстТеста();
	
КонецПроцедуры

Процедура ПослеКаждогоТеста(ОписаниеСобытия) Экспорт
	
	УстановитьКонтекстИсполнения(ОписаниеСобытия.Модуль, ОписаниеСобытия.Набор);
	
КонецПроцедуры

Процедура ПослеТестовогоНабора(ОписаниеСобытия) Экспорт
	
	УстановитьКонтекстИсполнения(ОписаниеСобытия.Модуль);
	
КонецПроцедуры

Процедура ПослеВсехТестов(ОписаниеСобытия) Экспорт
	
	УстановитьКонтекстИсполнения();
	
КонецПроцедуры

#КонецОбласти
