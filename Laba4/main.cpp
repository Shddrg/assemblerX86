//Это лаба 4
#include <iostream>

// Указываем компилятору использовать C-соглашение о вызовах, чтобы избежать искажения имен (name mangling)
extern "C" double find_max_asm(double start, double end, double step);

int main() {
    setlocale(LC_ALL, "Russian");

    double start = -1.0;
    double end = 2.0;
    double step;

    std::cout << "Вычисление максимального значения функции на отрезке [-1; 2]" << std::endl;
    std::cout << "Введите шаг интегрирования (например, 0.1): ";
    std::cin >> step;

    if (step <= 0) {
        std::cout << "Ошибка: Шаг должен быть больше нуля!" << std::endl;
        return 1;
    }

    // Вызов функции из модуля на ассемблере
    double max_val = find_max_asm(start, end, step);

    std::cout << "Максимальное значение функции: " << max_val << std::endl;

    return 0;
}