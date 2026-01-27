
export function assert<T>(p: T | undefined | null): asserts p is T {
    if (!p) {
        throw new Error('Assertion failed');
    }
}

export function assertInstanceOf<T>(p: any, type: new (...args: any[]) => T): asserts p is T {
    if (!(p instanceof type)) {
        throw new Error('Assertion failed');
    }
}
