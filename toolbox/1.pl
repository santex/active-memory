# USAGE
	#$data = &pack('B3B5nAA', @fields);
#	@fields = &unpack('B3B5nAA', $data);

sub pack {
  local ($template) = shift(@_);
  local (@data) = @_;
  local ($_);
  local ($type, $len);
  local ($new_tmplt);
  local ($new_field);
  local ($current_bits);
  local ($wrapup);
  local (@tmp_data);

  # see if the template has any bitfields (they make life difficult)
  if ($template =~ m/[Bb]/) {
    $_ = $template;

    # check each field, in order
    while (($type, $len) = m/([A-Za-z])([0-9*]*)/) {
      s/[A-Za-z][0-9*]*//;

      # see if this is one of those nasty bitfields
      if (($type eq 'b') || ($type eq 'B')) {
	if (!$len) { $len = 1; } # accept 'B' as 'B1'

	$current_bits += $len;
	$new_field .= shift(@data);

	if (($current_bits == 8) || ($current_bits == 16)
		|| ($current_bits == 32))
	{
	  $new_tmplt .= $type . $current_bits;
	  push(@tmp_data, $new_field);
	  $current_bits = 0;
	  $new_field = '';
	}
	elsif ($current_bits > 32) {
	  die 'bitfields must at least be aligned on 32-bit words, stopped';
	}
      } # end of processing bit fields

      elsif ($current_bits) {
	  die 'fields must at least be aligned on 32-bit words, stopped';
      }

      # this was not a bitfield, so it gets passed through to the new template
      else {
        push(@tmp_data, shift(@data));
	$new_tmplt .= $type . $len;
      }
    }

    pack($new_tmplt, @tmp_data);

  }

  # this is how easy it is without bitfields
  else {
    pack($template, @data);
  }
}

sub unpack {
  local ($template) = shift(@_);
  local ($data) = shift(@_);
  local ($_);
  local ($i);
  local ($type, $len);
  local ($pos);
  local ($new_tmplt);
  local ($wrapup);
  local ($current_bits);
  local ($next_bitfield);
  local ($field_with_bits);
  local ($bits_left);
  local ($tmp_field);
  local (@bitfields, @tmp_fields, @unfinished, @return);

  # see if the template has any bitfields (they make life difficult)
  if ($template =~ m/[Bb]/) {
    $_ = $template;

    # check each field, in order
    while (($type, $len) = m/([A-Za-z])([0-9*]*)/) {
      s/[A-Za-z][0-9*]*//;

      # see if this is one of those nasty bitfields
      if (($type eq 'b') || ($type eq 'B')) {
	if (!$len) { $len = 1; } # accept 'B' as 'B1'
	push(@tmp_fields, $len);	# keep track of the number of bits

	# append this to any previous adjacent bitfield that is unaligned
	$current_bits += $len;
	if ($current_bits == 8) {
	  $new_tmplt .= 'C';
	  $wrapup = 1;
	}
	elsif ($current_bits == 16) {
	  $new_tmplt .= 'n';
	  $wrapup = 1;
	}
	elsif ($current_bits == 32) {
	  $new_tmplt .= 'N';
	  $wrapup = 1;
	}
	elsif ($current_bits > 32) {
	  die 'bitfields must at least be aligned on 32-bit words, stopped';
	}

	#
	# Store the location of the collection of bitfields,
	# the aggregate size of the contiguous bitfields, and
	# IN REVERSE ORDER the size of each bitfield.
	#
	# This reverse order makes it a _lot_ easier to extract
	# the individual bitfields from the conglomerate. But,
	# it does make another layer of reversing necessary to
	# have the bitfields end up in the right order in the
	# final returned list.
	#
	if ($wrapup) {
	  push(@bitfields, $pos);
	  push(@bitfields, $current_bits);
	  while (@tmp_fields) {
	    push(@bitfields, pop(@tmp_fields)); # note the backwards order
	  }
	  ++$pos;
	  $current_bits = 0;
	  $wrapup = 0;
	}
      } # end of processing bit fields

      elsif ($current_bits) {
	  die 'fields must at least be aligned on 32-bit words, stopped';
      }

      # this was not a bitfield, so it gets passed through to the new template
      else {
        ++$pos;
	$new_tmplt .= $type . $len;
      }
    }

    #
    # the new template has been constructed, so unpack the structure
    #

    @unfinished = unpack($new_tmplt, $data);

    #
    # now find the bitfields and put them into the return list
    #

    $pos = 0;
    $next_bitfield = shift(@bitfields);

    while (@unfinished) {
      if ($pos == $next_bitfield) {
	$field_with_bits = shift(@unfinished);
        $bits_left = shift(@bitfields);

	while ($bits_left) {
          $len = shift(@bitfields);
	  for ($tmp_field = '', $i = 0; $i < $len; ++$i) {
	    $tmp_field = (($field_with_bits & 1) ? '1' : '0') . $tmp_field;
	    $field_with_bits = $field_with_bits >> 1;
	  }
	  push(@tmp_fields, $tmp_field);
	  $bits_left -= $len;
	}

	while (@tmp_fields) { push(@return, pop(@tmp_fields)); }
        $next_bitfield = shift(@bitfields);
      }
      else {
	push(@return, shift(@unfinished));
	++$pos;
      }
    }
    @return;
  }

  # this is how easy it is without bitfields
  else {
    unpack($template, $data);
  }
}

1;



# unpack-bitfields.pl
# 	original by David Noble
#	changes for real binary date in unpack plus minor changes
#	by Mathias Koerber

# USAGE
#	$data = &bitpack('B3B5nAA', @fields);
#	@fields = &bitunpack('B3B5nAA', $data);

sub bitpack {
  local ($template) = shift(@_);
  local (@data) = @_;
  local ($_);
  local ($type, $len);
  local ($new_tmplt);
  local ($new_field);
  local ($current_bits);
  local ($wrapup);
  local (@tmp_data);

  # see if the template has any bitfields (they make life difficult)
  if ($template =~ m/[Bb]/) {
    $_ = $template;

    # check each field, in order
    while (($type, $len) = m/([A-Za-z])([0-9*]*)/) {
      s/[A-Za-z][0-9*]*//;

      # see if this is one of those nasty bitfields
      if (($type eq 'b') || ($type eq 'B')) {
	if (!$len) { $len = 1; } # accept 'B' as 'B1'

	$current_bits += $len;
	$new_field .= shift(@data);

	if (($current_bits == 8) || ($current_bits == 16)
		|| ($current_bits == 32))
	{
          if ($current_bits == 8)  { $new_tmplt .= 'C'; };
          if ($current_bits == 16) { $new_tmplt .= 'I'; };
          if ($current_bits == 32) { $new_tmplt .= 'L';  };
		
	  push(@tmp_data, oct($new_field));
	  $current_bits = 0;
	  $new_field = '';
	}
	elsif ($current_bits > 32) {
	  die 'bitfields must at least be aligned on 32-bit words, stopped';
	}
      } # end of processing bit fields

      elsif ($current_bits) {
	  die 'fields must at least be aligned on 32-bit words, stopped';
      }

      # this was not a bitfield, so it gets passed through to the new template
      else {
        push(@tmp_data, shift(@data));
	$new_tmplt .= $type . $len;
      }
    }

    pack($new_tmplt, @tmp_data);

  }

  # this is how easy it is without bitfields
  else {
    pack($template, @data);
  }
}

sub bitunpack {
  local ($template) = shift(@_);
  local ($data) = shift(@_);
  local ($_);
  local ($i);
  local ($type, $len);
  local ($pos);
  local ($new_tmplt);
  local ($wrapup);
  local ($current_bits);
  local ($next_bitfield);
  local ($field_with_bits);
  local ($bits_left);
  local ($tmp_field);
  local (@bitfields, @tmp_fields, @unfinished, @return);

  # see if the template has any bitfields (they make life difficult)
  if ($template =~ m/[Bb]/) {
    $_ = $template;

    # check each field, in order
    while (($type, $len) = m/([A-Za-z])([0-9*]*)/) {
      s/[A-Za-z][0-9*]*//;

      # see if this is one of those nasty bitfields
      if (($type eq 'b') || ($type eq 'B')) {
	if (!$len) { $len = 1; } # accept 'B' as 'B1'
	push(@tmp_fields, $len);	# keep track of the number of bits

	# append this to any previous adjacent bitfield that is unaligned
	$current_bits += $len;
	if ($current_bits == 8) {
	  $new_tmplt .= 'C';
	  $wrapup = 1;
	}
	elsif ($current_bits == 16) {
	  $new_tmplt .= 'n';
	  $wrapup = 1;
	}
	elsif ($current_bits == 32) {
	  $new_tmplt .= 'N';
	  $wrapup = 1;
	}
	elsif ($current_bits > 32) {
	  die 'bitfields must at least be aligned on 32-bit words, stopped';
	}

	#
	# Store the location of the collection of bitfields,
	# the aggregate size of the contiguous bitfields, and
	# IN REVERSE ORDER the size of each bitfield.
	#
	# This reverse order makes it a _lot_ easier to extract
	# the individual bitfields from the conglomerate. But,
	# it does make another layer of reversing necessary to
	# have the bitfields end up in the right order in the
	# final returned list.
	#
	if ($wrapup) {
	  push(@bitfields, $pos);
	  push(@bitfields, $current_bits);
	  while (@tmp_fields) {
	    push(@bitfields, pop(@tmp_fields)); # note the backwards order
	  }
	  ++$pos;
	  $current_bits = 0;
	  $wrapup = 0;
	}
      } # end of processing bit fields

      elsif ($current_bits) {
	  die 'fields must at least be aligned on 32-bit words, stopped';
      }

      # this was not a bitfield, so it gets passed through to the new template
      else {
        ++$pos;
	$new_tmplt .= $type . $len;
      }
    }

    #
    # the new template has been constructed, so unpack the structure
    #

    @unfinished = unpack($new_tmplt, $data);

    #
    # now find the bitfields and put them into the return list
    #

    $pos = 0;
    $next_bitfield = shift(@bitfields);

    while (@unfinished) {
      if ($pos == $next_bitfield) {
	$field_with_bits = shift(@unfinished);
        $bits_left = shift(@bitfields);

	while ($bits_left) {
          $len = shift(@bitfields);
#	  for ($tmp_field = '', $i = 0; $i < $len; ++$i) {
#	    $tmp_field = (($field_with_bits & 1) ? '1' : '0') . $tmp_field;
#           $tmp_field += ($field_with_bits & 1);
#           $tmp_field >> 1;
#	    $field_with_bits = $field_with_bits >> 1;
#	    }
 	  $tmp_field = ($field_with_bits & ((2**$len)-1));
          $field_with_bits = $field_with_bits >> $len;
#	  $tmp_field << 1;	# correct for the last shift
	  push(@tmp_fields, $tmp_field);
	  $bits_left -= $len;
	}

	while (@tmp_fields) { push(@return, pop(@tmp_fields)); }
        $next_bitfield = shift(@bitfields); $pos++;
      }
      else {
	push(@return, shift(@unfinished));
	++$pos;
      }
    }
    @return;
  }

  # this is how easy it is without bitfields
  else {
    unpack($template, $data);
  }
}

1;

