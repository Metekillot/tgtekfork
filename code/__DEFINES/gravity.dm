//singularity defines
/// Singularity is stage 1 (1x1)
#define STAGE_ONE 1
/// Singularity is stage 2 (3x3)
#define STAGE_TWO 3
/// Singularity is stage 3 (5x5)
#define STAGE_THREE 5
/// Singularity is stage 4 (7x7)
#define STAGE_FOUR 7
/// Singularity is stage 5 (9x9)
#define STAGE_FIVE 9
/// Singularity is stage 6 (11x11)
#define STAGE_SIX 11 //From supermatter shard

// Minimum energy needed to reach a stage
/// Singularity stage 1 energy requirement
#define STAGE_ONE_ENERGY_REQUIREMENT 1
/// Singularity stage 2 energy requirement
#define STAGE_TWO_ENERGY_REQUIREMENT 200
/// Singularity stage 3 energy requirement
#define STAGE_THREE_ENERGY_REQUIREMENT 500
/// Singularity stage 4 energy requirement
#define STAGE_FOUR_ENERGY_REQUIREMENT 1000
/// Singularity stage 5 energy requirement
#define STAGE_FIVE_ENERGY_REQUIREMENT 2000
/// Singularity stage 6 energy requirement (also needs to consume a SM shard)
#define STAGE_SIX_ENERGY_REQUIREMENT 3000

// These values get the median number between two stages to prevent expansion/shrinkage immediately
/// Singularity stage 1
#define STAGE_ONE_ENERGY ((STAGE_TWO_ENERGY_REQUIREMENT - STAGE_ONE_ENERGY_REQUIREMENT) * 0.5) + STAGE_ONE_ENERGY_REQUIREMENT
/// Singularity stage 2
#define STAGE_TWO_ENERGY ((STAGE_THREE_ENERGY_REQUIREMENT - STAGE_TWO_ENERGY_REQUIREMENT) * 0.5) + STAGE_TWO_ENERGY_REQUIREMENT
/// Singularity stage 3
#define STAGE_THREE_ENERGY ((STAGE_FOUR_ENERGY_REQUIREMENT - STAGE_THREE_ENERGY_REQUIREMENT) * 0.5) + STAGE_THREE_ENERGY_REQUIREMENT
/// Singularity stage 4
#define STAGE_FOUR_ENERGY ((STAGE_FIVE_ENERGY_REQUIREMENT - STAGE_FOUR_ENERGY_REQUIREMENT) * 0.5) + STAGE_FOUR_ENERGY_REQUIREMENT
/// Singularity stage 5
#define STAGE_FIVE_ENERGY ((STAGE_SIX_ENERGY_REQUIREMENT - STAGE_FIVE_ENERGY_REQUIREMENT) * 0.5) + STAGE_FIVE_ENERGY_REQUIREMENT
/// Singularity stage 6 (hardcoded at 4000 since there is no stage 7)
#define STAGE_SIX_ENERGY 4000

/**
 * The point where gravity is negative enough to pull you upwards.
 * That means walking checks for a ceiling instead of a floor, and you can fall "upwards"
 *
 * This should only be possible on multi-z maps because it works like shit on maps that aren't.
 */
#define NEGATIVE_GRAVITY -1
/// Used to indicate no gravity
#define ZERO_GRAVITY 0
#define STANDARD_GRAVITY 1 //Anything above this is high gravity, anything below no grav until negative gravity
/// The gravity strength threshold for high gravity damage.
#define GRAVITY_DAMAGE_THRESHOLD 3
/// The scaling factor for high gravity damage.
#define GRAVITY_DAMAGE_SCALING 0.5
/// The maximum [BRUTE] damage a mob can take from high gravity per second.
#define GRAVITY_DAMAGE_MAXIMUM 1.5
