# HEADER

This is my _home-manager_ configuration

It uses **nixvim** to manage my neovim configuration


here's some inline markdown: $\dfrac{1}{2}$

```c
#include <stdio.h>

typedef char* mychar_t;


int main(void) {
    printf("hello world!\n");
    (void)malloc(sizeof(char)*3);
    float v = 0.0;
    char c = '1';
    return 0;
}

void* myfunc(double arg) {};
```

```python
from typing import Iterator

# This is an example
class Math:
    @staticmethod
    def fib(n: int) -> Iterator[int]:
        """Fibonacci series up to n."""
        a, b = 0, 1
        while a < n:
            yield a
            a, b = b, a + b

result = sum(Math.fib(42))
print(f"The answer is {result}")

```

Derivative definition: $$
\lim_{h\to\infty} \dfrac{f(x_0 + h) - f(x_0)}{h}
$$

