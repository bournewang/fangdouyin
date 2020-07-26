import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
      data: {
          comment_pop: false
      }
  },
  getters: {
      get_comment_pop: state => state.data.comment_pop
  },
  mutations: {
      SET_COMMENT_POP:(state, data) => {
          state.data.comment_pop = data
      }
  },
  actions: {}
});
