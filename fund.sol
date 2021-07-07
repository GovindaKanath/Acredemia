// Fund ICO

// Version del compilador
pragma solidity ^0.8.4;

contract fund_ico {
    // Numero maximo de fund a la venta
    uint public max_fund = 1000000;
    
    // Tasa de Conversion USD a fund
    uint public usd_to_fund = 1000;
    
    // Numero total de fund comprados por inversionistas
    uint public total_fund_bought = 0;
    
    // mapeo de direccion de inversionista a activos en fund y usd_to_fund
    mapping(address=>uint)equity_fund;
    mapping(address=>uint)equity_usd;
    
    // verificando si inversionista puede comprar tokens
    modifier can_buy_fund(uint usd_invested) {
        require(usd_invested * usd_to_fund + total_fund_bought <= max_fund);
        _;
    }
    
    // Obtener el capital invertido en tokens
    
    function equity_in_fund(address investor)external view returns (uint) {
        return equity_fund[investor];
    }
    
    // Obtener el capital invertido en dolares USD
    
    function equity_in_usd(address investor)external view returns (uint) {
        return equity_usd[investor];
    }
    
    //comprando tokens
    
    function buy_fund(address investor, uint usd_invested)external can_buy_fund(usd_invested) {
        uint fund_bought = usd_invested * usd_to_fund;
        equity_fund[investor] += fund_bought;
        
        equity_usd[investor] = equity_fund[investor]/1000;
        total_fund_bought += fund_bought;
    }
    
    //vendiendo tokens
    
    function sell_fund(address investor, uint fund_sold)external {
        equity_fund[investor] -= fund_sold;
        equity_usd[investor] = equity_fund[investor]/1000;
        total_fund_bought -= fund_sold;
    }
    

}
