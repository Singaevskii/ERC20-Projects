// Лицензия для этого контракта — MIT
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Импорт интерфейса IERC20 для взаимодействия с токенами стандарта ERC20
import {IERC20} from "./IERC20.sol";

// Контракт для обмена токенов ERC20 на эфир (и обратно)
contract TokenExchange {
    // Объявляем переменную token для взаимодействия с контрактом токена
    IERC20 token;

    // Переменная для хранения адреса владельца контракта
    address owner;

    // Модификатор, позволяющий выполнять функции только владельцу контракта
    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner"); // Проверяем, что вызвавший адрес — владелец
        _; // Выполняем оставшуюся часть функции
    }

    // Конструктор, который вызывается при развёртывании контракта
    // Устанавливает адрес токена и адрес владельца контракта
    constructor(address _token) {
        token = IERC20(_token); // Инициализируем контракт токена
        owner = msg.sender; // Устанавливаем владельцем адрес того, кто развернул контракт
    }

    // Функция покупки токенов, оплачиваемых в эфире
    function buy() public payable {
        uint amount = msg.value; // Получаем количество эфира, отправленного вызвавшим эту функцию (в wei)

        require(amount >= 1, "Minimum 1 wei required"); // Условие: минимальная сумма 1 wei (для простоты)

        uint currentBalance = token.balanceOf(address(this)); // Получаем баланс токенов у контракта
        require(currentBalance >= amount, "Not enough tokens available"); // Убеждаемся, что контракт имеет достаточно токенов для продажи

        token.transfer(msg.sender, amount); // Переводим токены пользователю
    }

    // Функция продажи токенов за эфир
    function sell(uint _amount) external {
        require(
            address(this).balance >= _amount,
            "Not enough ether in contract"
        ); // Проверяем, достаточно ли эфира у контракта
        require(
            token.allowance(msg.sender, address(this)) >= _amount,
            "Allowance not sufficient"
        ); // Убеждаемся, что контракту разрешено списывать указанное количество токенов

        // Переводим токены от продавца к контракту
        token.transferFrom(msg.sender, address(this), _amount);

        // Возвращаем эфир пользователю, использующему функцию sell
        (bool ok, ) = msg.sender.call{value: _amount}(""); // Отправляем эфир обратно
        require(ok, "Failed to send ether"); // Проверяем, что перевод эфира успешен
    }

    // Функция для пополнения контракта эфиром, доступная только владельцу
    function topUp() external payable onlyOwner {}

    // Функция, которая вызывается автоматически, когда контракт получает эфир напрямую
    receive() external payable {
        buy(); // Автоматически покупаем токены на полученные средства
    }
}
