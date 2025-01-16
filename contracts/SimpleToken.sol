// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Импортируем стандартный контракт ERC20
import "./ERC20.sol";
// Импортируем расширение для возможности сжигания токенов (Burnable)
import "./ERC20Burnable.sol";

contract SimpleToken is ERC20, ERC20Burnable {
    // Переменная для хранения адреса владельца контракта
    address owner;

    // Модификатор, разрешающий выполнение функции только владельцем контракта
    modifier onlyOwner() {
        // Проверяем, что отправитель (msg.sender) является владельцем
        require(owner == msg.sender);
        // Если условие выполнено, продолжаем выполнение функции
        _;
    }

    // Конструктор контракта, который выполняется один раз при его деплое
    // Устанавливает начального владельца и выпускает (минтит) токены для отправителя
    constructor(address initialOwner) ERC20("SimpleToken", "SMT") {
        // Устанавливаем владельца контракта
        owner = initialOwner;
        // Выпускаем 5 токенов с количеством десятичных знаков, соответствующих стандарту
        _mint(msg.sender, 5 * 10 ** decimals());
    }

    // Функция выпуска новых токенов, доступная только владельцу контракта
    function mint(address to, uint256 amount) public onlyOwner {
        // Выпускаем указанное количество токенов для адреса to
        _mint(to, amount);
    }
}
