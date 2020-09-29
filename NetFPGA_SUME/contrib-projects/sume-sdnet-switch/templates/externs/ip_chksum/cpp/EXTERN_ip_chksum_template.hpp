#ifndef SDNET_ENGINE_@MODULE_NAME@
#define SDNET_ENGINE_@MODULE_NAME@

#include "sdnet_lib.hpp"

#undef RESULT_WIDTH

#define RESULT_WIDTH 16

namespace SDNET {

//######################################################
class @MODULE_NAME@ { // UserEngine
public:

	// tuple types
	struct @EXTERN_NAME@_input_t {
		static const size_t _SIZE = 161;
		_LV<1> stateful_valid_0;
		_LV<4> version;
		_LV<4> ihl;
		_LV<8> tos;
		_LV<16> totalLen;
		_LV<16> identification;
		_LV<3> flags;
		_LV<13> fragOffset;
		_LV<8> ttl;
		_LV<8> protocol;
		_LV<16> hdrChecksum;
		_LV<32> srcAddr;
		_LV<32> dstAddr;
		@EXTERN_NAME@_input_t& operator=(_LV<161> _x) {
			stateful_valid_0 = _x.slice(160,160);
			version = _x.slice(159,156);
			ihl = _x.slice(155,152);
			tos = _x.slice(151,144);
			totalLen = _x.slice(143,128);
			identification = _x.slice(127,112);
			flags = _x.slice(111,109);
			fragOffset = _x.slice(108,96);
			ttl = _x.slice(95,88);
			protocol = _x.slice(87,80);
			hdrChecksum = _x.slice(79,64);
			srcAddr = _x.slice(63,32);
			dstAddr = _x.slice(31,0);
			return *this;
		}
		_LV<161> get_LV() { return (stateful_valid_0,version,ihl,tos,totalLen,identification,flags,fragOffset,ttl,protocol,hdrChecksum,srcAddr,dstAddr); }
		_LV<160> get_IP_data() { 
			hdrChecksum = _LV<16>(0);
			return (version,ihl,tos,totalLen,identification,flags,fragOffset,ttl,protocol,hdrChecksum,srcAddr,dstAddr);
		}
		operator _LV<161>() { return get_LV(); } 
		std::string to_string() const {
			return std::string("(\n")  + "\t\tstateful_valid_0 = " + stateful_valid_0.to_string() + "\n" + "\t\tversion = " + version.to_string() + "\n" + "\t\tihl = " + ihl.to_string() + "\n" + "\t\ttos = " + tos.to_string() + "\n" + "\t\ttotalLen = " + totalLen.to_string() + "\n" + "\t\tidentification = " + identification.to_string() + "\n" + "\t\tflags = " + flags.to_string() + "\n" + "\t\tfragOffset = " + fragOffset.to_string() + "\n" + "\t\tttl = " + ttl.to_string() + "\n" + "\t\tprotocol = " + protocol.to_string() + "\n" + "\t\thdrChecksum = " + hdrChecksum.to_string() + "\n" + "\t\tsrcAddr = " + srcAddr.to_string() + "\n" + "\t\tdstAddr = " + dstAddr.to_string() + "\n" + "\t)";
		}
		@EXTERN_NAME@_input_t() {} 
		@EXTERN_NAME@_input_t( _LV<1> _stateful_valid_0, _LV<4> _version, _LV<4> _ihl, _LV<8> _tos, _LV<16> _totalLen, _LV<16> _identification, _LV<3> _flags, _LV<13> _fragOffset, _LV<8> _ttl, _LV<8> _protocol, _LV<16> _hdrChecksum, _LV<32> _srcAddr, _LV<32> _dstAddr) {
			stateful_valid_0 = _stateful_valid_0;
			version = _version;
			ihl = _ihl;
			tos = _tos;
			totalLen = _totalLen;
			identification = _identification;
			flags = _flags;
			fragOffset = _fragOffset;
			ttl = _ttl;
			protocol = _protocol;
			hdrChecksum = _hdrChecksum;
			srcAddr = _srcAddr;
			dstAddr = _dstAddr;
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

		_LV<160> input = @EXTERN_NAME@_input.get_IP_data();

		_LV<2*RESULT_WIDTH> temp1 = _LV<2*RESULT_WIDTH>(0);
		for (int i=0; i < 10; i++) {
			temp1 = temp1 + input.slice((i+1)*RESULT_WIDTH-1, i*RESULT_WIDTH);
		}

		// add carry overs back into result
		_LV<RESULT_WIDTH> temp2 = temp1.slice(2*RESULT_WIDTH-1, RESULT_WIDTH) + temp1.slice(RESULT_WIDTH-1,0);

		// invert result
		@EXTERN_NAME@_output.result = ~temp2;

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
