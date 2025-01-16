// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC20Metadata - Расширенный интерфейс для стандарта ERC20
/// @dev Этот интерфейс добавляет функции для получения имени, символа и количества десятичных знаков токена.
import "./IERC20.sol";

interface IERC20Metadata is IERC20 {
    /// @notice Возвращает имя токена (например, "Ethereum")
    function name() external view returns (string memory);

    /// @notice Возвращает символ токена (например, "ETH")
    function symbol() external view returns (string memory);

    /// @notice Возвращает количество десятичных знаков токена
    /// @dev Обычно это 18, как у ETH, но может быть другим значением.
    function decimals() external view returns (uint8);
}
