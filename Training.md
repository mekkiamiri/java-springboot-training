# Mastering Modern Java: Functional to Advanced

This training covers the evolution of Java from version 8 to 21. Each module includes a "Quick Concept" and a "Code Challenge."

---

## Module 1: Functional Interfaces & Lambdas
Modern Java is built on **Functional Interfaces** (interfaces with exactly one abstract method).

### The Core Four
1. **Predicate<T>**: Returns boolean (`test`).
2. **Function<T, R>**: Transforms T to R (`apply`).
3. **Consumer<T>**: Performs action, returns void (`accept`).
4. **Supplier<T>**: Produces a value (`get`).

### Exercise: Custom Functional Logic
Instead of writing a loop, let's use a `Predicate` to filter a list.

```java
import java.util.function.Predicate;
import java.util.List;
import java.util.ArrayList;

public class LambdaLab {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6);
        
        // CHALLENGE: Create a Predicate that checks for even numbers
        Predicate<Integer> isEven = n -> n % 2 == 0;
        
        numbers.forEach(n -> {
            if (isEven.test(n)) System.out.println("Even: " + n);
        });
    }
}
