#ifndef SDNET_ENGINE_@MODULE_NAME@
#define SDNET_ENGINE_@MODULE_NAME@

#include "sdnet_lib.hpp"

#undef READ_OP
#undef WRITE_OP

#undef OP_WIDTH
#undef REG_WIDTH
#undef INDEX_WIDTH
#undef INPUT_WIDTH
#undef REG_DEPTH

#define READ_OP    0
#define WRITE_OP   1

#define OP_WIDTH 8
#define REG_WIDTH @REG_WIDTH@
#define INDEX_WIDTH @INDEX_WIDTH@
#define INPUT_WIDTH (OP_WIDTH + REG_WIDTH + INDEX_WIDTH + 1)
#define REG_DEPTH (1 << INDEX_WIDTH)

#define REG_@PREFIX_NAME@_DEFAULT 0 

namespace SDNET {

//######################################################
class @MODULE_NAME@ { // UserEngine
public:

	// tuple types
	struct @EXTERN_NAME@_input_t {
		static const size_t _SIZE = INPUT_WIDTH;
		_LV<1> stateful_valid;
		_LV<INDEX_WIDTH> index;
		_LV<REG_WIDTH> newVal;
		_LV<OP_WIDTH> opCode;
		@EXTERN_NAME@_input_t& operator=(_LV<INPUT_WIDTH> _x) {
			stateful_valid = _x.slice(INPUT_WIDTH-1,INPUT_WIDTH-1);
			index = _x.slice(OP_WIDTH+REG_WIDTH+INDEX_WIDTH-1,OP_WIDTH+REG_WIDTH);
			newVal = _x.slice(OP_WIDTH+REG_WIDTH-1,OP_WIDTH);
			opCode = _x.slice(OP_WIDTH-1,0);
			return *this;
		}
		_LV<INPUT_WIDTH> get_LV() { return (stateful_valid,index,newVal,opCode); }
		operator _LV<INPUT_WIDTH>() { return get_LV(); } 
		std::string to_string() const {
			return std::string("(\n")  + "\t\tstateful_valid = " + stateful_valid.to_string() + "\n" + "\t\tindex = " + index.to_string() + "\n" + "\t\tnewVal = " + newVal.to_string() + "\n" + "\t\topCode = " + opCode.to_string() + "\n" + "\t)";
		}
		@EXTERN_NAME@_input_t() {} 
		@EXTERN_NAME@_input_t( _LV<1> _stateful_valid, _LV<INDEX_WIDTH> _index, _LV<REG_WIDTH> _newVal, _LV<OP_WIDTH> _opCode) {
			stateful_valid = _stateful_valid;
			index = _index;
			newVal = _newVal;
			opCode = _opCode;
		}
	};
	struct @EXTERN_NAME@_output_t {
		static const size_t _SIZE = REG_WIDTH;
		_LV<REG_WIDTH> result;
		@EXTERN_NAME@_output_t& operator=(_LV<REG_WIDTH> _x) {
			result = _x.slice(REG_WIDTH-1,0);
			return *this;
		}
		_LV<REG_WIDTH> get_LV() { return (result); }
		operator _LV<REG_WIDTH>() { return get_LV(); } 
		std::string to_string() const {
			return std::string("(\n")  + "\t\tresult = " + result.to_string() + "\n" + "\t)";
		}
		@EXTERN_NAME@_output_t() {} 
		@EXTERN_NAME@_output_t( _LV<REG_WIDTH> _result) {
			result = _result;
		}
	};

	// engine members
	std::string _name;
	@EXTERN_NAME@_input_t  @EXTERN_NAME@_input;
	@EXTERN_NAME@_output_t @EXTERN_NAME@_output;


	// TODO: ***************************
	// TODO: *** USER ENGINE MEMBERS ***
	// TODO: ***************************

	// register to store state between packets 
	_LV<REG_WIDTH> @PREFIX_NAME@_reg[REG_DEPTH]; // 2^INDEX_WIDTH entries


	// engine ctor
	@EXTERN_NAME@_t(std::string _n, std::string _filename = "") : _name(_n) {

		// TODO: **********************************
		// TODO: *** USER ENGINE INITIALIZATION ***
		// TODO: **********************************

		for (int i=0; i < REG_DEPTH; i++) {
			@PREFIX_NAME@_reg[i] = _LV<REG_WIDTH>(REG_@PREFIX_NAME@_DEFAULT);
		}

	}

        // engine function
        void operator()() {
                std::cout << "===================================================================" << std::endl;
                std::cout << "Entering engine " << _name << std::endl;
                // input and inout tuples:
                std::cout << "initial input and inout tuples:" << std::endl;
                std::cout << "  @EXTERN_NAME@_input = " << @EXTERN_NAME@_input.to_string() << std::endl;
                // clear internal and output-only tuples:
                std::cout << "clear internal and output-only tuples" << std::endl;
                @EXTERN_NAME@_output = 0;
                std::cout << "  @EXTERN_NAME@_output = " << @EXTERN_NAME@_output.to_string() << std::endl;

                // TODO: *********************************
                // TODO: *** USER ENGINE FUNCTIONALITY ***
                // TODO: *********************************

                // Update state
                if ((@EXTERN_NAME@_input.stateful_valid.to_ullong() == 1) & (@EXTERN_NAME@_input.index.to_ullong() < REG_DEPTH)) {
                        if (@EXTERN_NAME@_input.opCode.to_ullong() == WRITE_OP) {
                                @PREFIX_NAME@_reg[@EXTERN_NAME@_input.index.to_ullong()] = @EXTERN_NAME@_input.newVal;
                        }
                }

                // Write output tuple
                if (@EXTERN_NAME@_input.index.to_ullong() < REG_DEPTH) {
                        @EXTERN_NAME@_output.result = @PREFIX_NAME@_reg[@EXTERN_NAME@_input.index.to_ullong()];
                } else {
                        @EXTERN_NAME@_output.result = _LV<REG_WIDTH>(REG_@PREFIX_NAME@_DEFAULT);
                }

                // print register contents
                std::cout << "final register contents:" << std::endl;
                for (int i=0; i < REG_DEPTH; i++) {
                        std::cout << "\t@PREFIX_NAME@_reg["<<i<<"] = " << @PREFIX_NAME@_reg[i].to_string() << std::endl;
                }

                // inout and output tuples:
                std::cout << "final inout and output tuples:" << std::endl;
                std::cout << "  @EXTERN_NAME@_output = " << @EXTERN_NAME@_output.to_string() << std::endl;
                std::cout << "Exiting engine " << _name << std::endl;
                std::cout << "===================================================================" << std::endl;
        }
};
//######################################################
// top-level DPI function
extern "C" void @MODULE_NAME@_DPI(const char*, int, const char*, int, int, int);


} // namespace SDNET

#endif // SDNET_ENGINE_@MODULE_NAME@
