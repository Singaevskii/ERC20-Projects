// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC20 Token Standard Interface
/// @dev Определяет стандартные функции и события для токенов ERC20
interface IERC20 {
    ///  value Количество переданных токенов
    event Transfer(address indexed from, address indexed to, uint256 value);
    ///  owner Владельца токенов
    ///  spender Тот, кому разрешено тратить токены
    ///  value Количество разрешённых токенов
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /// Возвращает общее количество токенов в обращении
    function totalSupply() external view returns (uint256);

    ///  Возвращает баланс токенов определённого аккаунта
    ///  account Адрес владельца
    function balanceOf(address account) external view returns (uint256);

    /// Переводит токены на другой адрес

    ///  Возвращает `true`, если перевод прошёл успешно
    function transfer(address to, uint256 amount) external returns (bool);

    ///Возвращает количество токенов, которое `spender` может потратить от имени `owner`

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    ///  Позволяет `spender` потратить `amount` токенов от имени вызывающего

    /// Возвращает `true`, если операция прошла успешно
    function approve(address spender, uint256 amount) external returns (bool);

    ///  Переводит токены от имени другого адреса (после вызова `approve`)

    /// Возвращает `true`, если перевод прошёл успешно
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
