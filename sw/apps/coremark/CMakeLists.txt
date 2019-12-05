set(COREMARK_SOURCES core_list_join.c core_main.c core_matrix.c core_state.c core_util.c pulp/core_portme.c)
include_directories(. pulp/.)
add_application(coremark "${COREMARK_SOURCES}")

