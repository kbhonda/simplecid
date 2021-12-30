use strict;
use warnings;

my $Num;
my $CID;
my $JIS;
my $raw;
$Num = sprintf "%02d", $ARGV[0];
$CID = $ARGV[1] * (94*94);

my $preamble = <<_PRE_;
(VTITLE )
(OFMLEVEL H 0)
(DESIGNSIZE R 10.000000)
(COMMENT DESIGNSIZE IS IN POINTS)
(COMMENT OTHER SIZES ARE MULTIPLES OF DESIGNSIZE)
(CHECKSUM O 0)
(MAPFONT D 0
   (FONTNAME scid$Num-raw)
   (FONTCHECKSUM O 0)
   (FONTAT R 1.000000)
   (FONTDSIZE R 10.000000)
   )
_PRE_

print $preamble;

foreach my $upper (1..94) {
foreach my $lower (1..94) {
$CID++;
#my $HEXCID = sprintf "%04X", $CID;
$JIS = sprintf "%04X", ($upper+32)*256 + ($lower+32);

print <<_PACKET_;
(CHARACTER H $JIS
   (CHARWD R 1.000000)
   (MAP
      (SETCHAR D $CID)
      )
   )
_PACKET_
}
}