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

why did it crash last time?

```plantuml
@startuml

interface List<T> {
    T get()
    add(T)
    addAll(List<T>)
}

class ArrayList<T> {
    T[] data
}

List <|-- ArrayList
@enduml
```


```asymptote
size(5cm);
include graph;

pair circumcenter(pair A, pair B, pair C)
{
  pair P, Q, R, S;
  P = (A+B)/2;
  Q = (B+C)/2;
  R = rotate(90, P) * A;
  S = rotate(90, Q) * B;
  return extension(P, R, Q, S);
}

pair incenter(pair A, pair B, pair C)
{
  real a = abs(angle(C-A)-angle(B-A)),
       b = abs(angle(C-B)-angle(A-B)),
       c = abs(angle(A-C)-angle(B-C));
  return (sin(a)*A + sin(b)*B + sin(c)*C) / (sin(a)+sin(b)+sin(c));
}

real dist_A_BC(pair A, pair B, pair C)
{
  real det = cross(B-A, C-A);
  return abs(det/abs(B-C));
}

pair A = (0, 0), B = (5, 0), C = (3.5, 4),
     O = circumcenter(A, B, C),
     I = incenter(A, B, C);
dot(A); dot(B); dot(C); dot(O, blue); dot(I, magenta);
draw(A--B--C--cycle, linewidth(2));
draw(Circle(O, abs(A-O)), blue+linewidth(1.5));
draw(Circle(I, dist_A_BC(I, A, B)), magenta+linewidth(1.5));
label("$A$", A, SW);
label("$B$", B, SE);
label("$C$", C, NE);
label("$O$", O, W);
label("$I$", I, E);

```

```dot

digraph finite_state_machine {
	rankdir=LR;
	node [shape = doublecircle]; LR_0 LR_3 LR_4 LR_8;
	node [shape = circle];
	LR_0 -> LR_2 [ label = "SS(B)" ];
	LR_0 -> LR_1 [ label = "SS(S)" ];
	LR_1 -> LR_3 [ label = "S($end)" ];
	LR_2 -> LR_6 [ label = "SS(b)" ];
	LR_2 -> LR_5 [ label = "SS(a)" ];
	LR_2 -> LR_4 [ label = "S(A)" ];
	LR_5 -> LR_7 [ label = "S(b)" ];
	LR_5 -> LR_5 [ label = "S(a)" ];
	LR_6 -> LR_6 [ label = "S(b)" ];
	LR_6 -> LR_5 [ label = "S(a)" ];
	LR_7 -> LR_8 [ label = "S(b)" ];
	LR_7 -> LR_5 [ label = "S(a)" ];
	LR_8 -> LR_6 [ label = "S(b)" ];
	LR_8 -> LR_5 [ label = "S(a)" ];
}

```
