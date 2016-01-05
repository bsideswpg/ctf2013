This is a crypto problem.

The player is provided with a shell script (with the encryption key
removed), two plaintext/ciphertext pairs, and the encrypted flag.

The shell script does nothing tricky - it encrypts the file provided
with AES-128 in OFB mode with a static IV.

DEFENSE OF HAVING TWO CIPHERTEXT/PLAINTEXT PAIRS: This allows a player
to confirm that their program works, by checking that they can break
one of the ciphertexts using the other pair.

All three ciphertexts were encrypted under the same key.

OFB mode, like CTR mode, turns whatever block cipher it uses into a stream
cipher, where the output of the cipher is used as a keystream which is XORed
with the plaintext. In OFB mode the keystream is generated based on the key
and the IV - the plaintext does not affect it.

When an IV is reused with the same key, the security of OFB-mode schemes is
completely destroyed - likewise with CTR mode and any other stream cipher.
If a plaintext/ciphertext pair can be obtained, XORing the two produces a
piece of keystream which can be XORed with unknown ciphertext to recover
plaintext.

The following Ruby program can recover the flag for this challenge:


    require 'base64'

    def fixed_xor(longer_str, shorter_str)
      longer = shorter_str.unpack("c*")
      shorter = longer_str.unpack("c*")
      # trim the longer string to be the same length as the shorter string
      longer = longer[0, shorter.length]
      longer.zip(shorter).map {|fst, snd| fst ^ snd}.pack("c*")
    end

    def bd(str)
      Base64.strict_decode64(str)
    end

    # XOR the first ciphertext/plaintext with each other
    keystream = fixed_xor(bd("kpO2++sUw3VH2gi9zOl0bQJxF1+zTjqygGsrOdffiOwJDXc="), "Cooking MC's like a pound of bacon")

    # XOR the keystream we now have with the encrypted flag
    puts fixed_xor(keystream, bd("k464+e4WwQpI60a9n+x2WQ4/KQurRBCsiConOv0="))

