﻿
////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий
  
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
    Если Внешняя Тогда
    	ПроверяемыеРеквизиты.Добавить("СсылкаНаСхему");
    КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
    Если ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;
    Если ЗначениеЗаполнено(ТекстСхемыJson) Тогда
        РегистрыСведений.инт_КэшированиеСхемOpenApi.ОбновитьДатуКэша(Ссылка);
    КонецЕсли;
    ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

