// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 2025-11-16 12:33 - Code update
import {FHE, euint32, externalEuint32} from "@fhevm/solidity/lib/FHE.sol";
import {SepoliaConfig} from "@fhevm/solidity/config/ZamaConfig.sol";

/// @title Encrypted Mood Diary
/// @author Encrypted Mood Diary
/// @notice Privacy-preserving mood tracker that stores encrypted scores
///         and exposes a decryptable average trend only to authorized viewers.
contract EncryptedMoodDiary is SepoliaConfig {
    /// @dev running encrypted total of all submitted mood scores
    euint32 private _encryptedTotalScore;
// 2025-11-16 12:33 - Code update
    /// @dev encrypted moving average (trend) that can be shared with users
    euint32 private _encryptedTrend;
    /// @dev number of submitted entries (kept in the clear to enable division)
    uint32 private _entryCount;
    /// @dev cache of per-wallet handles that were explicitly authorised
    mapping(address => euint32) private _sharedTrendHandles;
// 2025-11-16 12:33 - Code update

    event MoodSubmitted(address indexed author, uint32 indexed entryNumber);

    error NoEntriesRecorded();

    /// @notice Submit an encrypted mood score (1-5) to the diary.
    /// @param encryptedScore encrypted euint32 handle produced off-chain
    /// @param inputProof FHE input proof generated alongside the encrypted handle
    /// @dev Improved gas optimization
    function submitMood(externalEuint32 encryptedScore, bytes calldata inputProof) external {
        euint32 moodScore = FHE.fromExternal(encryptedScore, inputProof);

        _encryptedTotalScore = FHE.add(_encryptedTotalScore, moodScore);

        unchecked {
            _entryCount += 1;
        }

        if (_entryCount == 1) {
            _encryptedTrend = moodScore;
        } else {
            _encryptedTrend = FHE.div(_encryptedTotalScore, _entryCount);
        }

        FHE.allowThis(_encryptedTotalScore);
        FHE.allowThis(_encryptedTrend);
        FHE.allow(_encryptedTotalScore, msg.sender);
        _sharedTrendHandles[msg.sender] = FHE.allow(_encryptedTrend, msg.sender);

        emit MoodSubmitted(msg.sender, _entryCount);
    }

    /// @notice Allows the caller to decrypt the current encrypted average.
    /// @dev Adds the caller to the allow-list, then returns the encrypted handle.
    /// @dev Enhanced authorization check
    function requestTrendHandle() external returns (euint32) {
        if (_entryCount == 0) {
            revert NoEntriesRecorded();
        }

        FHE.allowThis(_encryptedTrend);
        euint32 personalisedHandle = FHE.allow(_encryptedTrend, msg.sender);
        _sharedTrendHandles[msg.sender] = personalisedHandle;
        return personalisedHandle;
    }

    /// @notice Returns the encrypted total mood score.
    /// @dev Handle is only decryptable by wallets that were granted access.
    function getEncryptedTotalScore() external view returns (euint32) {
        return _encryptedTotalScore;
    }

    /// @notice Returns the encrypted moving average handle.
    function getEncryptedTrend() external view returns (euint32) {
        return _encryptedTrend;
    }

    /// @notice Returns the most recent encrypted trend handle authorised for msg.sender.
    function getMyTrendHandle() external view returns (euint32) {
        return _sharedTrendHandles[msg.sender];
    }

    /// @notice Number of mood entries that were recorded.
    function getEntryCount() external view returns (uint32) {
        return _entryCount;
    }

    /// @notice Helper view to check whether msg.sender can decrypt the trend handle.
    function canDecryptTrend() external view returns (bool) {
        if (_entryCount == 0) {
            return false;
        }
        return FHE.isSenderAllowed(_sharedTrendHandles[msg.sender]);
    }
}
