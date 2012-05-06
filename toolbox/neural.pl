	use AI::NeuralNet::Mesh;

    # Create a mesh with 2 layers, 2 nodes/layer, and one output node.
	my $net = new AI::NeuralNet::Mesh(2,2, 1);

	# Teach the network the AND function
	$net->learn([0,0],[0]);
	$net->learn([0,1],[0]);
	$net->learn([1,0],[0]);
	$net->learn([1,1],[1]);

	# Present it with two test cases
	my $result_bit_1 = $net->run([0,1])->[0];
	my $result_bit_2 = $net->run([1,1])->[0];

	# Display the results
	print "AND test with inputs (0,1): $result_bit_1\n";
	print "AND test with inputs (1,1): $result_bit_2\n";


