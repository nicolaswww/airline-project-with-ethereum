pragma solidity ^0.4.23;

contract Airline {

    address public owner;

    struct Customer {
        uint loyaltyPoints;
        uint totalFlights;
    }

    struct Flight {
        string name;
        uint256 price;
    }

    uint etherPerPoint = 0.5 ether;

    Flight[] public flights;

    mapping(address => Customer) public customers;
    mapping(address => Flight[]) public customerFlights;
    mapping(address => uint) public customerTotalFlights;

    event FlightPurchased(address indexed customer, uint price);

    constructor() public {
        owner = msg.sender;
        flights.push(Flight('Tokio', 4 ether));
        flights.push(Flight('Germany', 1 ether));
        flights.push(Flight('Madrid', 2 ether));
    }

    function buyFlight(uint flightIndex) public payable {
        Flight storage flight = flights[flightIndex];
        require(msg.value == flight.price, 'Price is invalid');

        Customer storage customer = customers[msg.sender];
        customer.loyaltyPoints += 5;
        customer.totalFlights += 1;
        customerFlights[msg.sender].push(flight);
        customerTotalFlights[msg.sender] ++;

        emit FlightPurchased(msg.sender, flight.price);
    }

    function totalFlights() public view returns (uint) {
        return flights.length;
    }

    function redeemLoyaltyPoints() public {
        Customer storage customer = customers[msg.sender];
        uint etherToRefund = etherPerPoint * customer.loyaltyPoints;
        msg.sender.transfer(etherToRefund);
        customer.loyaltyPoints = 0;
    }

    function getRefundableEther() public view returns (uint) {
        return etherPerPoint * customers[msg.sender].loyaltyPoints;
    }

    function getAirlineBalance() public view returns (uint) {
        address airlineAddress = this;
        return airlineAddress.balance;
    }

    modifier isOwner() {
        require(msg.sender == owner, 'User is not owner');
        _;
    }
}