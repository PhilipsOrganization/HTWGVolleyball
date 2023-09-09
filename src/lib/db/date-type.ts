import { Type, Platform, ValidationError, type EntityProperty } from '@mikro-orm/core';

export class DateType extends Type<Date, string> {

    convertToDatabaseValue(value: Date | string | undefined, _platform: Platform): string {
        if (value instanceof Date) {
            return value.toISOString().substr(0, 10);
        }

        if (!value || value.toString().match(/^\d{4}-\d{2}-\d{2}$/)) {
            return value as string;
        }

        throw ValidationError.invalidType(DateType, value, 'JS');
    }

    convertToJSValue(value: Date | string | undefined, _platform: Platform): Date {
        if (!value || value instanceof Date) {
            return value as Date;
        }

        const date = new Date(value);

        if (date.toString() === 'Invalid Date') {
            throw ValidationError.invalidType(DateType, value, 'database');
        }

        return date;
    }

    getColumnType(prop: EntityProperty, _platform: Platform) {
        return `date(${prop.length})`;
    }

}