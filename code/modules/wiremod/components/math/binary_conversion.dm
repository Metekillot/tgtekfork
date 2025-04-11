/**
 * # Binary Conversion Component
 *
 * Return an array of binary digits from a number input.
 */
/obj/item/circuit_component/binary_conversion
	display_name = "Binary Conversion"
	desc = "Splits a decimal number into an array of binary digits, or bits, represented as 1 or 0 and often used in boolean or binary operations like AND, OR and XOR."
	category = "Math"

	/// One number
	var/datum/port/input/number
	/// Many binary digits
	var/datum/port/output/bit_array



/obj/item/circuit_component/binary_conversion/populate_ports()
	number = add_input_port("Number", PORT_TYPE_NUMBER, order = 1.1)
	bit_array = add_output_port("Bit Array", PORT_TYPE_LIST(PORT_TYPE_NUMBER), order = 1.2)

/obj/item/circuit_component/binary_conversion/pre_input_received()
	// Set the bit array to 0 before any processing
	bit_array.set_output(list(0))


/obj/item/circuit_component/binary_conversion/input_received(datum/port/input/port)
	if
	var/to_convert = number.value
