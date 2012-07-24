use Term::ReadKey;
ReadMode('cbreak');
print "Press keys to see their ASCII values.  Use Ctrl-C to quit.\n";
while (1) {
    $char = ReadKey(0);
    last unless defined $char;
    printf(" Decimal: %d\tHex: %x\n", ord($char), ord($char));
}
ReadMode('normal'); 
