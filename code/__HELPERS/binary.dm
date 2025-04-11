#define DEFAULT_NUMBER_OUT

/// Convert a given number to its binary representation
/// Using two's complement, only supports integers
/proc/num2binary(num, out_type = "list", to_bits = null)
	if(isnan(num))
		return null
	var/list/output = list()
	if(num == 0)
		if(isnum(to_bits) && to_bits > 0)
			// Add leading zeros
			for(var/i = 1, i <= to_bits, i++)
				output += 0
		if(out_type == "text")
			return jointext(output, "")
		else
			return output
	if(out_type =! "text" && out_type =! "list")
		CRASH("num2binary: only supports output in list or text format")
	var/morphed = floor(abs(num))
	while(TRUE)
		var/new_bit = morphed % 2
		output += new_bit
		morphed = floor(morphed / 2)
		if(morphed == 0)
			break
	if(num < 0)
		for(var/bit in output)
			bit = !bit
		// And add one
		for(var/index = 1,index <= length(output), index++)
			if(output[index] == 0)
				output[index] = 1
				break
			output[index] = 0
			if(index == length(output))
				output.Insert(1, 1)
				break

/*
6
011 unreversed
inverse
100
0101





*/


