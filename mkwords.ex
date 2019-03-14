
include std/io.e
include std/pretty.e

procedure main()
	
	sequence words = read_lines( "words.txt" )
	
	integer fn = open( "words.e", "w" )
	
	puts( fn, "public constant WORDS_LIST = " )
	pretty_print( fn, words, {2} )
	puts( fn, "\n" )
	
	close( fn )
	
end procedure

main()
