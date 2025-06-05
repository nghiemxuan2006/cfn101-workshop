import os
import sys

def fibonacci(n):
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        return b

if __name__ == "__main__":
    # test ecs task container out of memory
    data = []
    for _ in range(5000):
        data.append("X" * 10**6)  # 1MB mỗi phần tử
    n = int(os.getenv("FIBONACCI_NUMBER", 2))  # Default to 2 if not provided
    if len(sys.argv) > 1:
        n = int(sys.argv[1])
    
    print(f"The {n}th Fibonacci number is: {fibonacci(n)}")