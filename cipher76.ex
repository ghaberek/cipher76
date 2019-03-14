--
-- Fallout 76 - How to Decipher the Nuclear Code Yourself, Without Using A Program
-- https://www.reddit.com/r/fo76/comments/9yc0w9/fallout_76_how_to_decipher_the_nuclear_code/ea0vqq8
--

include std/cmdline.e
include std/console.e
include std/convert.e
include std/error.e
include std/io.e
include std/pretty.e
include std/sort.e
include std/text.e
include std/types.e
include words.e

--
-- A text file containing over 466k English words.
-- https://github.com/dwyl/english-words
--
constant WORDS_FILE = "words.txt"
constant ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

function verify_keyword( sequence word )
	
	if length( word ) = 0 then
		error:crash( "length(word) = 0" )
	end if
	
	if t_alpha( word ) = FALSE then
		error:crash( "t_alpha(word) = FALSE" )
	end if
	
	return text:upper( word )
end function

function verify_piece( sequence piece )
	
	if length( piece ) != 2 then
		error:crash( "length(piece) != 2" )
	end if
	
	if t_alpha( piece[1] ) = FALSE then
		error:crash( "t_alpha(piece[1]) = FALSE" )
	end if
	
	if t_digit( piece[2] ) = FALSE then
		error:crash( "t_digit(piece[2]) = FALSE" )
	end if
	
	return piece
end function

function verify_pieces( sequence pieces )
	
	if length( pieces ) != 8 then
		error:crash( "length(pieces) != 8" )
	end if
	
	for i = 1 to length( pieces ) do
		pieces[i] = verify_piece( pieces[i] )
	end for
	
	return pieces
end function

function get_cipherkey( sequence keyword )
	
	-- start with alphabet
	sequence cipherkey = ALPHABET
	sequence removed = ""
	
	-- remove letters from keyword
	for i = 1 to length( keyword ) do
		
		if find( keyword[i], removed ) then
			continue
		end if
		
		integer index = find( keyword[i], cipherkey )
		
		if index then
			cipherkey = remove( cipherkey, index )
			removed = append( removed, keyword[i] )
		end if
		
	end for
	
	-- append the removed letters to the remaining alphabet
	return removed & cipherkey
end function

function get_anagram( sequence cipherkey, sequence pieces )
	
	sequence anagram = repeat( ' ', 8 )
	
	for i = 1 to 8 do
		
		integer index = find( pieces[i][1], cipherkey )
		anagram[i] = ALPHABET[index]
		
	end for
	
	return anagram
end function

function get_codeword( sequence anagram )
	
	sequence foundword = ""
	sequence sortedgram = sort( anagram )
	
/*
	
	integer file = open( WORDS_FILE, "r" )
	if not file then
		error:crash( "file = 0" )
	end if
	
	object line = gets( file )
	while sequence( line ) do
		
		sequence codeword = text:trim( line )
		sequence sortedword = sort( codeword )
		
		if equal( sortedgram, sortedword ) then
			foundword = codeword
			exit
		end if
		
		line = gets( file )
	end while
	
	close( file )
	
*/
	
	for i = 1 to length( WORDS_LIST ) do
		
		sequence codeword = WORDS_LIST[i]
		sequence sortedword = sort( codeword )
		
		if equal( sortedgram, sortedword ) then
			foundword = codeword
			exit
		end if
		
	end for
	
	return foundword
end function

function get_ciphercode( sequence cipherkey, sequence anagram )
	
	sequence ciphercode = repeat( ' ', 8 )
	
	for i = 1 to 8 do
		
		integer index = find( anagram[i], ALPHABET )
		ciphercode[i] = cipherkey[index]
		
	end for
	
	return ciphercode
end function

function get_launchcode( sequence ciphercode, sequence pieces )
	
	sequence launchcode = repeat( ' ', 8 )
	
	for i = 1 to 8 do
		
		for j = 1 to 8 do
			
			if ciphercode[i] = pieces[j][1] then
				launchcode[i] = pieces[j][2]
				break
			end if
			
		end for
		
	end for
	
	return launchcode
end function

procedure main()
	
	integer verbose = 0
	sequence cmd = command_line()
	sequence params = {}
	
	if length( cmd ) < 11 then
		puts( STDOUT, "usage:\n" )
		puts( STDOUT, "  cipher76 keyword piece1..piece8\n" )
		return
	end if
	
	for i = 3 to length( cmd ) do
		
		if equal( cmd[i], "-v" ) then
			verbose = 1
			
		else
			params &= { cmd[i] }
		end if
		
	end for
	
	sequence keyword = verify_keyword( params[1] )
	sequence pieces = verify_pieces( params[2..9] )
	
	sequence cipherkey = get_cipherkey( keyword )
	printf( STDOUT, " cipher key: %s\n", {cipherkey} )
	
	sequence anagram = get_anagram( cipherkey, pieces )
	printf( STDOUT, "    anagram: %s\n", {anagram} )
	
	sequence codeword = get_codeword( anagram )
	printf( STDOUT, "  code word: %s\n", {codeword} )
	
	sequence ciphercode = get_ciphercode( cipherkey, codeword )
	printf( STDOUT, "cipher code: %s\n", {ciphercode} )
	
	sequence launchcode = get_launchcode( ciphercode, pieces )
	printf( STDOUT, "launch code: %s\n", {launchcode} )
	
end procedure

main()
