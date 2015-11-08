`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:12:24 10/05/2015
// Design Name:   quickhull.v
// 
////////////////////////////////////////////////////////////////////////////////

module m_quickhull_tb;

	// Inputs
	reg CLK100MHZ;
	reg CPU_RESETN;
	reg [4095:0] points;
	reg [15:0] SS;

	// Outputs
	wire [4095:0] convexPoints;
	wire [7:0] convexSetSize;
	wire [15:0] positiveCrossCount;
	wire [31:0] crossValue;
	wire [15:0] lnIndex;
	wire [15:0] ptCount;
	wire [31:0] currLine;
	wire [15:0] currPoint;
	wire [15:0] furthest;
	wire [15:0] xMinPoint;
	wire [15:0] xMaxPoint;
	wire signed [31:0] furthestCrossValue;

	wire QINITIAL, QFIND_MAX, QFIND_MIN, QHULL_START, QCROSS, QHULL_RECURSE, QEND;
	// File
	integer file_results;

	// Parameters
	parameter CLK_PERIOD = 20;

	// Instantiate the Unit Under Test (UUT)
	m_port_ultra_quickhull_processor UUT(
		//Inputs
		.CLK100MHZ(CLK100MHZ),
		.CPU_RESETN(CPU_RESETN),
		.SS(SS),
		.points(points),
		//Outputs
		.convexPoints(convexPoints),
		.convexSetSizeOutput(convexSetSize),
		.positiveCrossCountOutput(positiveCrossCount),
		.crossValueOutput(crossValue),
		.lnIndexOutput(lnIndex),
		.ptCountOutput(ptCount),
		.currentLineOutput(currLine),
		.currentPointOutput(currPoint),
		.furthestOutput(furthest),
		.furthestCrossValueOutput(furthestCrossValue),
		.xMinPointOutput(xMinPoint),
		.xMaxPointOutput(xMaxPoint),
		.QINITIAL(QINITIAL),
		.QFIND_MAX(QFIND_MAX),
		.QFIND_MIN(QFIND_MIN),
		.QHULL_START(QHULL_START),
		.QCROSS(QCROSS),
		.QHULL_RECURSE(QHULL_RECURSE),
		.QEND(QEND)
	);


	initial begin : CLOCK_GENERATOR
		CLK100MHZ = 0;
		
		forever begin
			# (CLK_PERIOD / 2) CLK100MHZ = ~CLK100MHZ;
		end
	end	
		
	integer counter;
	
	initial begin : STIMULUS
		
		//SS = 16;
		//SS = 32;
		//SS = 64;
		SS = 256;
		
		// 16 size, 32 range
		//points = 4096'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001001100011000000111010001000100001100000010100000001100000000000101110000110000001001000111010001001100001000000100100000110100010011000011010001000100011111000111010001111000001000000100000000101100000111000001100000010100001001000110000000011100011001;
		
		// 32 size, 32 range
		//points = 4096'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011001000000100001110000001011000111010001100100011011000100000000101100000010000010100000111100011111000101010001111100011111000110010001101100001010000100010000011100011010000011000000001000001100000111000000111000000111000110000000101000011000000101010000111000000110000101010001110000010101000111110001011000000101000011110000111000000011000000000000011000001101000110100001100100011111000010110000101000001010000001010001100000001000000100110000000100010011000010100001100000001001000001000001101000000011;
		
		// 64 size, 32 range
		//points = 4096'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100000101000100000000110000000110000001100001010100001001000100010001010100010110000010010000100100010110000001010001111000001110000100100000111000001011000000000000011100001001000001100001100000011000000111110001111100011110000101000001010100010110000011010001000000011100000010100001101000000001000100010001100100000100000010100000111100011001000010110001001000010101000110000000101000010111000100010000101100011110000011010001001100011001000010100000000100001101000111110001110100011011000001000001111100000100000101110000011100010110000000010000001000001110000000100000011000001101000101100001101100010110000110010000110100001100000111010001111000011101000001000001101000010000000100010000110000000010000000100000010100010101000111110001011000000000000111110001000000000000000100100000100100001111000110010000010000011010000110000001110000010001000111010001101100011000000110000000110100010110000010010001100100000111000100000000000100010001000011110000011100001010000010010001111100000101000000010000010100000000;

		points = 4096'b0001011000001111000011110000011100011000000101010000110100011001000001000000101100010111000111000001011000000011000100100001000000010100000000000000011000011101000010100000010000001101000101110001100100001110000001110000000100001100000001110000011000010010000111110000000100000100000110100000110000010111000100100001000100001010000001100000001100000011000100100000010000011101000000110000101000000100000110100000011000010000000001110000000000010011000001110000110000010111000000000001110000011100000101100000000000000101000100110000011100011110000000000000000000001110000000010001100100010001000111010001010000000111000010010000111100010110000100100001010100011111000100100001000000010100000011100000011000000011000010100001100100011110000011100001111000011001000000110001110000001010000001010000111100011000000010110001110100010101000011110000001100011111000110000001111000011111000001100000100100010110000100110001101000011101000011000001011000011001000101000000011100000011000111000001101100001001000000110001001100011100000000010001110000010001000100010000101000000100000000100001110000010100000011100000000100010010000001000000111100001100000110000000011000000010000010010000011000011111000000110001110100000101000010100000011000001011000000110000110000011110000011010000101100000101000000000000111000011111000001000000001000001111000011010000100100000111000000110001100100010010000110110000110100001000000000110000000000000000000001110000010000010001000111010001110100010000000101100000110100010011000111110000011100001010000011110001010000010001000001000000101100000101000001010001111100000010000100000000010000011111000101010000100100010011000000010000000100001011000001110000111000001101000001010000001000001100000010110001010000000110000011010000100100011110000100000001101000011110000100100000000000000101000011110000011100011010000010100000100100010000000111000001101100000010000101010001010000011110000110000001111100001011000100000000001100010111000000110001010000010010000001010001000000000100000001000001010100001101000111000000010000001101000110010000100100010010000010100000100100000000000111000000001100001100000100000001001000000101000101000000010000010010000111010000011000010111000010000001010000001111000001010000111100011100000001100000001100011011000100010001101000010100000011100000011000010011000101100000011000001100000000000001000100011001000000100000110000011011000011010000111100001110000011000001001100011100000010110001110000001001000100010001110000000111000101010000001000010110000111010001000100011010000010110001110100011110000111100001100000010111000011110000111100000111000000000001000100001001000110100000100000001110000100100000011100000110000010000001000100010100000101110001011000010100000011010001000000000001000010000001011000000101000010110001011100010011000100000000011000001111000101010000011100001101000101000000010100000100000000100001000100001010000011000000111000000110000111000000001000000010000010110000010100001100000100100000011000001101000010010000111100001011000111000000100100011010000101010001011100001011000100100001100100000101000111110000110100001100000110000001111000001111000000000000000100001101000110100000011000011100000101100001101100000110000100100001100000000101000101110000101000001100000110000000011100001001000010010000011100011110000101110000000000000000000100000000001000010101000111010000111000000010000101010001111000001001000111100000111000011101000001100000110000011110000001100001010100010111000110110000000000001001000001110001000100001100000101010000010000001000000011100000011000010010000111100001111000000001000010110000110100010110000100110000011100010101000001010001001100001010000011000001111000001100000001010000110000000001000011010000001100011110000101100000010000001001000101010001010100011111000101100000000000011101000110110000101000001111000100010001111000000000000111010001110100011000000111010001111100010001000101100000010000001010000100110001110000000111000010000000110000010100000100010000100100000001000001100001110000000001000000010001110000000001000100100001111000011000000110010001111100011001;
		
		// Wait for global reset to finish
		#100;
				
		// Generate a reset
		CPU_RESETN = 0;	#20;
		CPU_RESETN = 1;	#20;
		
		// Give a long time for machine to finish
		//#8000;
		//32000;
		#500000;
		
		// Wait for global reset to finish
		#100;

	end
		  
endmodule

