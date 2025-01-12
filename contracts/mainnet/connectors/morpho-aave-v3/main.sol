//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;
import "./helpers.sol";
import "./events.sol";

abstract contract MorphoAaveV3 is Helpers, Events {
	/**
	 * @dev Deposit ETH/ERC20_Token.
	 * @notice Deposit a token to Morpho Aave for lending.
	 * @param _tokenAddress The address of underlying token to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to deposit. (For max: `uint256(-1)`)
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens deposited.
	 */
	function deposit(
		address _tokenAddress,
		uint256 _amount,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.supply(address(_tokenContract), _amt, address(this), max_iteration);

		setUint(_setId, _amt);

		_eventName = "LogDeposit(address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Deposit ETH/ERC20_Token.
	 * @notice Deposit a token to Morpho Aave for lending.
	 * @param _tokenAddress The address of underlying token to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to deposit. (For max: `uint256(-1)`)
	 * @param _maxIteration The maximum number of iterations allowed during the matching process.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens deposited.
	 */
	function depositWithMaxIterations(
		address _tokenAddress,
		uint256 _amount,
		uint256 _maxIteration,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.supply(address(_tokenContract), _amt, address(this), _maxIteration);

		setUint(_setId, _amt);

		_eventName = "LogDepositWithMaxIterations(address,uint256,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_maxIteration,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Deposit ETH/ERC20_Token on behalf of a user.
	 * @notice Deposit a token to Morpho Aave for lending on behalf of a user.
	 * @param _tokenAddress The address of underlying token to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to deposit. (For max: `uint256(-1)`)
	 * @param _onBehalf The address of user on behalf of whom we want to deposit.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens deposited.
	 */
	function depositOnBehalf(
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.supply(address(_tokenContract), _amt, _onBehalf, max_iteration);

		setUint(_setId, _amt);

		_eventName = "LogDepositOnBehalf(address,uint256,address,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_onBehalf,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Deposit ETH/ERC20_Token on behalf of a user.
	 * @notice Deposit a token to Morpho Aave for lending on behalf of a user with max iterations.
	 * @param _tokenAddress The address of underlying token to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to deposit. (For max: `uint256(-1)`)
	 * @param _onBehalf The address of user on behalf of whom we want to deposit.
	 * @param _maxIteration The maximum number of iterations allowed during the matching process.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens deposited.
	 */
	function depositOnBehalfWithMaxIterations (
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		uint256 _maxIteration,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.supply(address(_tokenContract), _amt, _onBehalf, _maxIteration);

		setUint(_setId, _amt);

		_eventName = "LogDepositOnBehalfWithMaxIterations(address,uint256,address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_onBehalf,
			_maxIteration,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Deposit ETH/ERC20_Token on behalf of a user.
	 * @notice Deposit a token to Morpho Aave for lending / collaterization.
	 * @param _tokenAddress The address of underlying token to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to deposit. (For max: `uint256(-1)`)
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens deposited.
	 */
	function depositCollateral(
		address _tokenAddress,
		uint256 _amount,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.supplyCollateral(address(_tokenContract), _amt, address(this));

		setUint(_setId, _amt);

		_eventName = "LogDepositCollateral(address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Deposit ETH/ERC20_Token on behalf of a user.
	 * @notice Deposit a token to Morpho Aave for lending / collaterization on behalf of a user.
	 * @param _tokenAddress The address of underlying token to deposit.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to deposit. (For max: `uint256(-1)`)
	 * @param _onBehalf The address of user on behalf to deposit.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens deposited.
	 */
	function depositCollateralOnBehalf(
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.supplyCollateral(address(_tokenContract), _amt, _onBehalf);

		setUint(_setId, _amt);

		_eventName = "LogDepositCollateralOnBehalf(address,uint256,address,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_onBehalf,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Borrow ETH/ERC20_Token.
	 * @notice Borrow a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to borrow.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to borrow.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens borrowed.
	 */
	function borrow(
		address _tokenAddress,
		uint256 _amount,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isETH = _tokenAddress == ethAddr;
		address _token = _isETH ? wethAddr : _tokenAddress;
		
		uint256 _borrowed = MORPHO_AAVE_V3.borrow(_token, _amt, address(this), address(this), max_iteration);

		convertWethToEth(_isETH, TokenInterface(_token), _borrowed);

		setUint(_setId, _borrowed);

		_eventName = "LogBorrow(address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_borrowed,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Borrow ETH/ERC20_Token.
	 * @notice Borrow a token from Morpho Aave V3.
	 * @param _tokenAddress The address of underlying token to borrow.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to borrow.
	 * @param _onBehalf The address of user on behalf to borrow.
	 * @param _receiver The address of receiver to receive the borrowed tokens. 
	   Note that if receiver is not the same as the borrower, receiver will receive WETH instead of ETH.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens borrowed.
	 */
	function borrowOnBehalf(
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		address _receiver,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isETH = _tokenAddress == ethAddr;
		address _token = _isETH ? wethAddr : _tokenAddress;

		uint256 _borrowed = MORPHO_AAVE_V3.borrow(_token, _amt, _onBehalf, _receiver, max_iteration);

		if(_receiver == address(this)) convertWethToEth(_isETH, TokenInterface(_token), _borrowed);

		setUint(_setId, _borrowed);

		_eventName = "LogBorrowOnBehalf(address,uint256,addresss,address,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_borrowed,
			_onBehalf,
			_receiver,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Borrow ETH/ERC20_Token.
	 * @notice Borrow a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to borrow.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to borrow.
	 * @param _receiver The address of receiver to receive the borrowed tokens.
	   Note that if receiver is not the same as the borrower, receiver will receive WETH instead of ETH.
	 * @param _maxIteration The maximum number of iterations to be used for borrow.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens borrowed.
	 */
	function borrowWithMaxIterations(
		address _tokenAddress,
		uint256 _amount,
		address _receiver,
		uint256 _maxIteration,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isETH = _tokenAddress == ethAddr;
		address _token = _isETH ? wethAddr : _tokenAddress;

		uint256 _borrowed = MORPHO_AAVE_V3.borrow(_token, _amt, address(this), _receiver, _maxIteration);

		if(_receiver == address(this)) convertWethToEth(_isETH, TokenInterface(_token), _borrowed);

		setUint(_setId, _borrowed);

		_eventName = "LogBorrowWithMaxIterations(address,uint256,addresss,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_borrowed,
			_receiver,
			_maxIteration,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Borrow ETH/ERC20_Token.
	 * @notice Borrow a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to borrow.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to borrow.
	 * @param _onBehalf The address of user on behalf to borrow.
	 * @param _receiver The address of receiver to receive the borrowed tokens.
	   Note that if receiver is not the same as the borrower, receiver will receive WETH instead of ETH.
	 * @param _maxIteration The maximum number of iterations to be used for borrow.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens borrowed.
	 */
	function borrowOnBehalfWithMaxIterations (
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		address _receiver,
		uint256 _maxIteration,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isETH = _tokenAddress == ethAddr;
		address _token = _isETH ? wethAddr : _tokenAddress;

		uint256 _borrowed = MORPHO_AAVE_V3.borrow(_token, _amt, _onBehalf, _receiver, _maxIteration);

		if(_receiver == address(this)) convertWethToEth(_isETH, TokenInterface(_token), _borrowed);

		setUint(_setId, _borrowed);

		_eventName = "LogBorrowOnBehalfWithMaxIterations(address,uint256,addresss,address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_borrowed,
			_onBehalf,
			_receiver,
			_maxIteration,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Withdraw ETH/ERC20_Token.
	 * @notice Withdraw a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to withdraw.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to withdraw. (For max: `uint256(-1)`)
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens withdrawed.
	 */
	function withdraw(
		address _tokenAddress,
		uint256 _amount,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isEth = _tokenAddress == ethAddr;
		address _token = _isEth? wethAddr : _tokenAddress;
		
		// Morpho will internally handle max amount conversion by taking the minimum of amount or supplied collateral.
		uint256 _withdrawn = MORPHO_AAVE_V3.withdraw(_token, _amt, address(this), address(this), max_iteration);

		convertWethToEth(_isEth, TokenInterface(_token), _withdrawn);

		setUint(_setId, _withdrawn);

		_eventName = "LogWithdraw(address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_withdrawn,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Withdraw ETH/ERC20_Token.
	 * @notice Withdraw a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to withdraw.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to withdraw. (For max: `uint256(-1)`)
	 * @param _onBehalf Address for which tokens are being withdrawn.
	 * @param _receiver Address to which tokens are being transferred.
	   Note that if receiver is not the same as the supplier, receiver will receive WETH instead of ETH.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens withdrawed.
	 */
	function withdrawOnBehalf(
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		address _receiver,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isEth = _tokenAddress == ethAddr;
		address _token = _isEth ? wethAddr : _tokenAddress;

		// Morpho will internally handle max amount conversion by taking the minimum of amount or supplied collateral.
		uint256 _withdrawn = MORPHO_AAVE_V3.withdraw(_token, _amt, _onBehalf, _receiver, max_iteration);

		if(_receiver == address(this)) convertWethToEth(_isEth, TokenInterface(_token), _withdrawn);

		setUint(_setId, _withdrawn);

		_eventName = "LogWithdrawOnBehalf(address,uint256,address,address,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_withdrawn,
			_onBehalf,
			_receiver,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Withdraw ETH/ERC20_Token.
	 * @notice Withdraw a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to withdraw.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to withdraw. (For max: `uint256(-1)`)
	 * @param _onBehalf Address for which tokens are being withdrawn.
	 * @param _receiver Address to which tokens are being transferred.
	   Note that if receiver is not the same as the supplier, receiver will receive WETH instead of ETH.
	 * @param _maxIteration Max number of iterations to run.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens withdrawed.
	 */
	function withdrawOnBehalfWithMaxIterations(
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		address _receiver,
		uint256 _maxIteration,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isEth = _tokenAddress == ethAddr;
		address _token = _isEth ? wethAddr : _tokenAddress;

		// Morpho will internally handle max amount conversion by taking the minimum of amount or supplied collateral.
		uint256 _withdrawn = MORPHO_AAVE_V3.withdraw(_token, _amt, _onBehalf, _receiver, _maxIteration);

		if(_receiver == address(this)) convertWethToEth(_isEth, TokenInterface(_token), _withdrawn);

		setUint(_setId, _withdrawn);

		_eventName = "LogWithdrawOnBehalfWithMaxIterations(address,uint256,address,address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_withdrawn,
			_onBehalf,
			_receiver,
			_maxIteration,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Withdraw ETH/ERC20 collateral token.
	 * @notice Withdraw a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to withdraw.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to withdraw. (For max: `uint256(-1)`)
	 * @param _receiver Address to which tokens are being transferred.
	   Note that if receiver is not the same as the supplier, receiver will receive WETH instead of ETH.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens withdrawed.
	 */
	function withdrawCollateral(
		address _tokenAddress,
		uint256 _amount,
		address _receiver,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isEth = _tokenAddress == ethAddr;
		address _token = _isEth ? wethAddr : _tokenAddress;

		uint256 _withdrawn = MORPHO_AAVE_V3.withdrawCollateral(_token, _amt, address(this), _receiver);

		if(_receiver == address(this)) convertWethToEth(_isEth, TokenInterface(_token), _withdrawn);

		setUint(_setId, _withdrawn);

		_eventName = "LogWithdrawCollateral(address,uint256,address,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_withdrawn,
			_receiver,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Withdraw ETH/ERC20 collateral token.
	 * @notice Withdraw a token from Morpho Aave.
	 * @param _tokenAddress The address of underlying token to withdraw.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to withdraw. (For max: `uint256(-1)`)
	 * @param _onBehalf Address for which tokens are being withdrawn.
	 * @param _receiver Address to which tokens are being transferred.
	   Note that if receiver is not the same as the supplier, receiver will receive WETH instead of ETH.
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens withdrawed.
	 */
	function withdrawCollateralOnBehalf(
		address _tokenAddress,
		uint256 _amount,
		address _onBehalf,
		address _receiver,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _amt = getUint(_getId, _amount);
		bool _isEth = _tokenAddress == ethAddr;
		address _token = _isEth ? wethAddr : _tokenAddress;

		uint256 _withdrawn = MORPHO_AAVE_V3.withdrawCollateral(_token, _amt, _onBehalf, _receiver);

		if(_receiver == address(this)) convertWethToEth(_isEth, TokenInterface(_token), _withdrawn);

		setUint(_setId, _withdrawn);

		_eventName = "LogWithdrawCollateralOnBehalf(address,uint256,address,address,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_withdrawn,
			_onBehalf,
			_receiver,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Payback ETH/ERC20_Token.
	 * @notice Payback a token to Morpho Aave.
	 * @param _tokenAddress The address of underlying token to payback.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _amount The amount of the token (in underlying) to payback. (For max: `uint256(-1)`)
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens paid back.
	 */
	function payback(
		address _tokenAddress,
		uint256 _amount,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.repay(address(_tokenContract), _amt, address(this));

		setUint(_setId, _amt);

		_eventName = "LogPayback(address,uint256,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_getId,
			_setId
		);
	}

	/**
	 * @dev Payback ETH/ERC20_Token.
	 * @notice Payback a token to Morpho Aave.
	 * @param _tokenAddress The address of underlying token to payback.(For ETH: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
	 * @param _onBehalf The address of user who's debt to repay.
	 * @param _amount The amount of the token (in underlying) to payback. (For max: `uint256(-1)`)
	 * @param _getId ID to retrieve amt.
	 * @param _setId ID stores the amount of tokens paid back.
	 */
	function paybackOnBehalf(
		address _tokenAddress,
		address _onBehalf,
		uint256 _amount,
		uint256 _getId,
		uint256 _setId
	)
		external
		payable
		returns (string memory _eventName, bytes memory _eventParam)
	{
		(
			TokenInterface _tokenContract,
			uint256 _amt
		) = _performEthToWethConversion(_tokenAddress, _amount, _getId);

		approve(_tokenContract, address(MORPHO_AAVE_V3), _amt);

		MORPHO_AAVE_V3.repay(address(_tokenContract), _amt, _onBehalf);

		setUint(_setId, _amt);

		_eventName = "LogPaybackOnBehalf(address,uint256,address,uint256,uint256)";
		_eventParam = abi.encode(
			_tokenAddress,
			_amt,
			_onBehalf,
			_getId,
			_setId
		);
	}

	/// @notice Approves a `manager` to borrow/withdraw on behalf of the sender.
    /// @param _manager The address of the manager.
    /// @param _isAllowed Whether `manager` is allowed to manage `msg.sender`'s position or not.
    function approveManager(address _manager, bool _isAllowed) 
		external 
		returns (string memory _eventName, bytes memory _eventParam)
	{
        MORPHO_AAVE_V3.approveManager(_manager, _isAllowed);
		
		_eventName = "LogApproveManger(address,bool)";
		_eventParam = abi.encode(
			_manager,
			_isAllowed
		);
    }

	/// @notice Updates the max iterations for a `repay` or a `withdraw`.
    /// @param _iterations New iteration count.
	function updateMaxIterations(uint256 _iterations)
		external
		returns (string memory _eventName, bytes memory _eventParam)
	{
		uint256 _oldIterations = max_iteration;
		max_iteration = _iterations;

		_eventName = "LogUpdateMaxIterations(uint256,uint256)";
		_eventParam = abi.encode(
			_oldIterations,
			max_iteration
		);
	}
}

contract ConnectV2MorphoAaveV3 is MorphoAaveV3 {
	string public constant name = "Morpho-AaveV3-v1.0";
}
