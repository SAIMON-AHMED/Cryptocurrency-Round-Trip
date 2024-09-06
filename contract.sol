// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoTrader {
    function roundTrip (
        int[] calldata walletBalances,
        int[] calldata networkFees
    ) public pure returns (int) {
        unchecked {

            int sum;
            int index;
            bool flag;
            int subSum;
            uint i = 0;  // Start index

            do {
                int total = walletBalances[i] - networkFees[i];
                sum += total;
                subSum += total;
                
                // If the current `total` is non-negative and the flag is false, set the flag and store the index
                if (total >= 0 && flag == false) {
                    flag = true;       // Indicate that we've found the first non-negative wallet balance
                    index = int(i);    // Store the index of this wallet
                } 
                // If `sub_sum` (cumulative sum up to this point) goes below 0, reset `sub_sum` and flag
                else if (subSum < 0) {
                    flag = false;  // Reset the flag since a negative sub_sum means no valid wallet was found
                    subSum = 0;   // Reset the local sub-sum
                }

                // Increment `i` circularly
                i = (i + 1) % walletBalances.length;  // Wrap around using modulo operator

            } while (i != 0);  // Continue until we complete a full circular loop

            // Final check: if both the global sum and the last sub_sum are non-negative, return the index of the valid wallet
            if (subSum >= 0 && sum >= 0) {
                return index;  // Return the index of the first valid wallet
            } else {
                return -1;     // Return -1 if no valid wallet was found, or the sum is negative
            }
        }
    }
}
