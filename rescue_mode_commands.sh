#!/bin/bash

# OVH VPS Password Reset via Rescue Mode
# IP: 141.95.149.88

echo "=== OVH VPS RESCUE MODE PASSWORD RESET ==="
echo ""

echo "1. SSH подключение в rescue mode:"
echo "ssh root@141.95.149.88"
echo "(Используйте пароль из email для rescue mode)"
echo ""

echo "2. Проверка дисков:"
echo "lsblk"
echo ""

echo "3. Монтирование основного диска:"
echo "mount /dev/sda1 /mnt"
echo "# Если sda1 не работает, попробуйте:"
echo "# mount /dev/vda1 /mnt"
echo ""

echo "4. Переход в систему:"
echo "chroot /mnt"
echo ""

echo "5. Сброс пароля root:"
echo "passwd root"
echo "# Введите новый пароль дважды"
echo ""

echo "6. Создание/сброс пароля ubuntu:"
echo "passwd ubuntu"
echo "# Введите новый пароль дважды"
echo ""

echo "7. Выход из chroot:"
echo "exit"
echo ""

echo "8. Размонтирование:"
echo "umount /mnt"
echo ""

echo "9. В OVH Manager:"
echo "   - Переключите Netboot обратно на 'Normal Boot'"
echo "   - Перезагрузите сервер"
echo ""

echo "10. Проверка доступа:"
echo "ssh root@141.95.149.88"
echo "# Или через KVM консоль с новым паролем"
echo ""

echo "=== ГОТОВО! ===" 