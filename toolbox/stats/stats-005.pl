 use Statistics::Contingency;

my @all_categories = 0..3;
 my $s = new Statistics::Contingency(categories => \@all_categories);
 
foreach(@all_categories) {
my $assigned_categories = $_; 
my $correct_categories=sprintf "%d" ,$_+rand 10;
  $s->add_result($assigned_categories, $correct_categories);
 }
 

 
 print $s->stats_table; # Show several stats in table form

 my $stats = $s->category_stats;
 my $show = {};
 
  while (my ($cat, $value) = each %$stats) {
    $show->{$cat} = $value;
  }
  
  



while (my ($cat, $value) = each %$stats) {
  print "Category '$cat': \n";  print "  Accuracy: $value->{accuracy}\n";
  print "  Precision: $value->{precision}\n";
  print "  F1: $value->{F1}\n";
}


         use Statistics::Descriptive;
         $stat = Statistics::Descriptive::Full->new();
         $stat->add_data(1,2,3,40); $mean = $stat->mean();
         $var  = $stat->variance();
         $tm   = $stat->trimmed_mean(0.25000);
#         $Statistics::Descriptive::Tolerance = 1e-10;


#print $var, " " ,$tm;
__DATA__
  
foreach(keys %$show){
   my ($cat, $value) = ($_,$stats->{$_});
   
   foreach my $key (keys %$value) {
        print "  $key: $value->{$key}\n";    
   }
}

