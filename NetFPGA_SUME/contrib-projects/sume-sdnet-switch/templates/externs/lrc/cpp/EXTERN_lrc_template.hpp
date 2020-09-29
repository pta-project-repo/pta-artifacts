#ifndef SDNET_ENGINE_@MODULE_NAME@
#define SDNET_ENGINE_@MODULE_NAME@

#include <math.h>
#include "sdnet_lib.hpp"

#define DATA_WIDTH @DATA_WIDTH@
#define RESULT_WIDTH @RESULT_WIDTH@

namespace SDNET {

//######################################################
class @MODULE_NAME@ { // UserEngine
public:

	// tuple types
	struct @EXTERN_NAME@_input_t {
		static const size_t _SIZE = DATA_WIDTH+1;
		_LV<1> stateful_valid;
		_LV<DATA_WIDTH> in_data;
		@EXTERN_NAME@_input_t& operator=(_LV<DATA_WIDTH+1> _x) {
			stateful_valid = _x.slice(DATA_WIDTH,DATA_WIDTH);
			in_data = _x.slice(DATA_WIDTH-1,0);
			return *this;
		}
		_LV<DATA_WIDTH+1> get_LV() { return (stateful_valid,in_data); }
		operator _LV<DATA_WIDTH+1>() { return get_LV(); } 
		std::string to_string() const {
			return std::string("(\n")  + "\t\tstateful_valid = " + stateful_valid.to_string() + "\n" + "\t\tin_data = " + in_data.to_string() + "\n" + "\t)";
		}
		@EXTERN_NAME@_input_t() {} 
		@EXTERN_NAME@_input_t( _LV<1> _stateful_valid, _LV<DATA_WIDTH> _in_data) {
			stateful_valid = _stateful_valid;
			in_data = _in_data;
		}
	};
	struct @EXTERN_NAME@_output_t {
		static const size_t _SIZE = RESULT_WIDTH;
		_LV<RESULT_WIDTH> result;
		@EXTERN_NAME@_output_t& operator=(_LV<RESULT_WIDTH> _x) {
			result = _x.slice(RESULT_WIDTH-1,0);
			return *this;
		}
		_LV<RESULT_WIDTH> get_LV() { return (result); }
		operator _LV<RESULT_WIDTH>() { return get_LV(); } 
		std::string to_string() const {
			return std::string("(\n")  + "\t\tresult = " + result.to_string() + "\n" + "\t)";
		}
		@EXTERN_NAME@_output_t() {} 
		@EXTERN_NAME@_output_t( _LV<RESULT_WIDTH> _result) {
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

	// engine ctor
	@MODULE_NAME@(std::string _n, std::string _filename = "") : _name(_n) {

		// TODO: **********************************
		// TODO: *** USER ENGINE INITIALIZATION ***
		// TODO: **********************************

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

		_LV<RESULT_WIDTH> result = _LV<RESULT_WIDTH>(0);
		_LV<RESULT_WIDTH> mask = _LV<RESULT_WIDTH>((1<<RESULT_WIDTH)-1); // 2^RESULT_WIDTH - 1
		_LV<RESULT_WIDTH> word = _LV<RESULT_WIDTH>(0);
		for (int i=0; i < (int)ceil((double)(DATA_WIDTH)/((double)RESULT_WIDTH)); i++) {
			word = @EXTERN_NAME@_input.in_data & mask;
			result = result ^ word;
			@EXTERN_NAME@_input.in_data = @EXTERN_NAME@_input.in_data >> RESULT_WIDTH;
		}

		@EXTERN_NAME@_output.result = result;

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
