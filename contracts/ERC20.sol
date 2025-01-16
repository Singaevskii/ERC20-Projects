// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./IERC20Metadata.sol";

abstract contract ERC20 is IERC20, IERC20Metadata {
    //абстрактный потому что не будем разворачивать
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256))
        private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, value);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 value
    ) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);

        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0) && to != address(0));
        _update(from, to, value); //уменьшает и увелиивает балансы при переводе
    }

    // Внутренняя функция для обновления балансов после перевода
    function _update(address from, address to, uint256 value) internal virtual {
        // Если отправитель — нулевой адрес, то увеличиваем общее количество токенов (минтинг)
        if (from == address(0)) {
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            // Проверяем, что у отправителя достаточно токенов
            require(fromBalance >= value);
            unchecked {
                _balances[from] = fromBalance - value;
            }
        }

        // Если получатель — нулевой адрес, то уменьшаем общее количество токенов (сжигание)
        if (to == address(0)) {
            unchecked {
                _totalSupply -= value;
            }
        } else {
            unchecked {
                _balances[to] += value;
            }
        }

        // Эмитируем событие Transfer после завершения перевода
        emit Transfer(from, to, value);
    }

    // Внутренняя функция для установки разрешений на перевод токенов
    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    // Внутренняя функция для установки разрешений с опциональным событием Approval
    function _approve(
        address owner,
        address spender,
        uint256 value,
        bool emitEvent
    ) internal virtual {
        require(owner != address(0) && spender != address(0));
        _allowances[owner][spender] = value;
        // Эмитируем событие Approval, если это необходимо
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    // Внутренняя функция для проверки и уменьшения разрешённого лимита (allowance)
    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= value);
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }

    // Внутренняя функция для выпуска новых токенов (минтинг)
    function _mint(address account, uint256 value) internal {
        require(account != address(0));
        _update(address(0), account, value);
    }

    // Внутренняя функция для сжигания токенов
    function _burn(address account, uint256 value) internal {
        require(account != address(0));
        _update(account, address(0), value);
    }
}
