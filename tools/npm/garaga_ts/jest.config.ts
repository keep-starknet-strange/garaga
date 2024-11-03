module.exports= {
    preset: 'ts-jest',
    testEnvironment: 'node',
    testMatch: ['**/tests/**/*.test.ts'],
    moduleFileExtensions: ['ts', 'js'],
    // transform: {
    //   '^.+\\.ts$': 'ts-jest'
    // },
    collectCoverage: true,
    collectCoverageFrom: ['src/**/*.ts'],
    transform: {
      '^.+\\.(ts|tsx|js|jsx)$': 'babel-jest',
    },
};
