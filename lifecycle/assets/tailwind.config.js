// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  mode: 'jit',
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      // gridTemplateColumns: {
      //   'hs': 'repeat(6, calc(50% - 40px))',
      // },
      // gridTemplateRows: {
      //   'hs':'minmax(150px, 1fr)',
      // },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ]
}
// .hs {
//   display: grid;
//   grid-gap: 10px;
//   grid-template-columns: repeat(6, calc(50% - 40px));
//   grid-template-rows: minmax(150px, 1fr);
// }