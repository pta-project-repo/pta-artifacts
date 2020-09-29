#ifndef SDNET_ENGINE_@MODULE_NAME@
#define SDNET_ENGINE_@MODULE_NAME@

#include "sdnet_lib.hpp"

#undef TIMER_WIDTH

#define TIMER_WIDTH @TIMER_WIDTH@

namespace SDNET {

//######################################################
class @MODULE_NAME@ { // UserEngine
public:

	// tuple types
	struct @EXTERN_NAME@_input_t {
		static const size_t _SIZE = 2;
		_LV<1> stateful_valid;
		_LV<1> valid;
		@EXTERN_NAME@_input_t& operator=(_LV<2> _x) {
			stateful_valid = _x.slice(1,1);
			valid = _x.slice(0,0);
			return *this;
		}
		_LV<2> get_LV() { return (stateful_valid,valid); }
		operator _LV<2>() { return get_LV(); } 
		std::string to_string() const {
			return std::string("(\n")  + "\t\tstateful_valid = " + stateful_valid.to_string() + "\n" + "\t\tvalid = " + valid.to_string() + "\n" + "\t)";
		}
		@EXTERN_NAME@_input_t() {} 
		@EXTERN_NAME@_input_t( _LV<1> _stateful_valid, _LV<1> _valid) {
			stateful_valid = _stateful_valid;
			valid = _valid;
		}
	};
	struct @EXTERN_NAME@_output_t {
		static const size_t _SIZE = TIMER_WIDTH;
		_LV<TIMER_WIDTH> result;
		@EXTERN_NAME@_output_t& operator=(_LV<TIMER_WIDTH> _x) {
			result = _x.slice(TIMER_WIDTH-1,0);
			return *this;
		}
		_LV<TIMER_WIDTH> get_LV() { return (result); }
		operator _LV<TIMER_WIDTH>() { return get_LV(); } 
		std::string to_string() const {
			return std::string("(\n")  + "\t\tresult = " + result.to_string() + "\n" + "\t)";
		}
		@EXTERN_NAME@_output_t() {} 
		@EXTERN_NAME@_output_t( _LV<TIMER_WIDTH> _result) {
			result = _result;
		}
	};

	// engine members
	std::string _name;
	@EXTERN_NAME@_input_t @EXTERN_NAME@_input;
	@EXTERN_NAME@_output_t @EXTERN_NAME@_output;


	// TODO: ***************************
	// TODO: *** USER ENGINE MEMBERS ***
	// TODO: ***************************

	_LV<TIMER_WIDTH> timer_r;

	// engine ctor
	@MODULE_NAME@(std::string _n, std::string _filename = "") : _name(_n) {

		// TODO: **********************************
		// TODO: *** USER ENGINE INITIALIZATION ***
		// TODO: **********************************
		timer_r = _LV<TIMER_WIDTH>(0);
	}

	// engine function
	void operator()() {
		std::cout << "===================================================================" << std::endl;
		std::cout << "Entering engine " << _name << std::endl;
		// input and inout tuples:
		std::cout << "initial input and inout tuples:" << std::endl;
		std::cout << "	@EXTERN_NAME@_input = " << @EXTERN_NAME@_input.to_string() << std::endl;
		// clear internal and output-only tuples:
		std::cout << "clear internal and output-only tuples" << std::endl;
		@EXTERN_NAME@_output = 0;
		std::cout << "	@EXTERN_NAME@_output = " << @EXTERN_NAME@_output.to_string() << std::endl;

		// TODO: *********************************
		// TODO: *** USER ENGINE FUNCTIONALITY ***
		// TODO: *********************************

		/* This implementation will not match the HDL simulations. 
		   Not really a timer, just increments by one for every packet */
		@EXTERN_NAME@_output.result = timer_r;
		timer_r = timer_r + _LV<TIMER_WIDTH>(1);

		// inout and output tuples:
		std::cout << "final inout and output tuples:" << std::endl;
		std::cout << "	@EXTERN_NAME@_output = " << @EXTERN_NAME@_output.to_string() << std::endl;
		std::cout << "Exiting engine " << _name << std::endl;
		std::cout << "===================================================================" << std::endl;
	}
};
//######################################################
// top-level DPI function
extern "C" void @MODULE_NAME@_DPI(const char*, int, const char*, int, int, int);


} // namespace SDNET

#endif // SDNET_ENGINE_@MODULE_NAME@
