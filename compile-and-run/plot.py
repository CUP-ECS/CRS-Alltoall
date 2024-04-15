class Mat:
    n_msgs = ""
    n_agg_msgs = ""
    name = ""
    std_times = ""
    tor_times = ""
    std_loc_times = ""
    tor_loc_times = ""
    rma_times = ""
    nodes = ""


    def __init__(self, name):
        self.n_msgs = list()
        self.n_agg_msgs = list()
        self.name = name

        self.std_times = list()
        self.tor_times = list()
        self.std_loc_times = list()
        self.tor_loc_times = list()
        self.rma_times = list()
        self.nodes = list()

    def add_data(self, name, node_count, n_msgs, n_agg_msgs, std_t, tor_t, std_loc_t, tor_loc_t, rma_t):
        if (name != self.name):
            print("Name incorrect (given %s, should be %s)\n"%(name, self.name))
            return

        self.n_msgs.append(n_msgs)
        self.n_agg_msgs.append(n_agg_msgs)

        self.std_times.append(std_t)
        self.tor_times.append(tor_t)
        self.std_loc_times.append(std_loc_t)
        self.tor_loc_times.append(tor_loc_t)
        self.rma_times.append(rma_t)

        self.nodes.append(node_count)


nodes = [2, 4, 8, 16, 32, 64]
mat_list = list()
mat_name=""
n_msgs=0
s_msgs=0
agg_msgs=0
std_time=0
tor_time=0
std_loc_time=0
tor_loc_time=0
idx = -1
init_time = 0
topo_time = 0
rma_time = 0
node_count = 0
for folder in ["quartz-mvapich", "quartz-openmpi"]:
    for op in ["alltoall", "alltoallv"]:
        f = open("%s/%s_crs.out"%(folder, op))
        for line in f:
            if "/g/g14/bienz1/CRS-Alltoall/benchmark_mats/" in line:
                mat_name = (line.rsplit('/')[-1]).rsplit('.')[0]
                print(mat_name)
                mat_list.append(Mat(mat_name))
                ctr = 0                

            elif "Max" in line or "Time" in line or "time" in line:
                n = (float)((line.rsplit('\n')[0]).rsplit(' ')[-1])

                if "Max Node" in line:
                    agg_msgs = n
                elif "Max N" in line:
                    n_msgs = n
                    node_count = nodes[ctr]
                    ctr += 1
                    print(line, node_count, ctr)
                elif "MPIX_Comm_init" in line: 
                    init_time = n
                elif "MPIX_Comm_topo" in line:
                    topo_time = n
                elif "Personalized Locality" in line:
                    std_loc_time=n
                elif "Nonblocking Locality" in line:
                    tor_loc_time=n
                elif "Personalized" in line:
                    std_time = n
                elif "Nonblocking" in line:
                    tor_time = n
                elif "RMA" in line:
                    rma_time = n

            if "MPI_Alltoall_crs Time (Nonblocking Locality VERSION)" in line:
                print(mat_name, node_count)
                mat_list[-1].add_data(mat_name, node_count, n_msgs, agg_msgs, std_time, tor_time, std_loc_time, tor_loc_time, rma_time)


        f.close()

        import matplotlib.backends
        import pyfancyplot as plt
        import matplotlib
        matplotlib.use("TkAgg")

        for mat in mat_list:
            xdata = mat.nodes
            n_col = 2
            print(mat.name)
            plt.add_luke_options()
            ax = plt.get_ax()
            ax.set_xscale('log', base=2)
            ax2 = ax.twinx()

            
            plt.line_plot(mat.std_times, x_data = xdata, tickmark = "-", label = "Personalized", color = 'black', ax = ax)
            plt.line_plot(mat.tor_times, x_data = xdata, tickmark = "--", label = "NonBlocking", color = 'black', ax = ax)
            plt.line_plot(mat.std_loc_times, x_data = xdata, tickmark = ":", label = "Personalized Locality", color = 'black', ax = ax)
            plt.line_plot(mat.tor_loc_times, x_data = xdata, tickmark = "-.", label = "NonBlocking Locality", color = 'black', ax = ax)
            if (op == "alltoall"):
                plt.line_plot(mat.rma_times, x_data = xdata, linestyle=(0, (3, 10, 1, 10)), label = "RMA", color = 'black', ax = ax)
                n_col = 3

            ax.legend(ncol=n_col, loc="upper center", bbox_to_anchor=(0., 1.1, 1., .102), frameon=False, fontsize=22)


            plt.line_plot(mat.n_msgs, x_data = xdata, tickmark = "*", label = "Standard Msgs", color='red', ax = ax2)
            plt.line_plot(mat.n_agg_msgs, x_data = xdata, tickmark = "s", label="Aggregated Msgs", color='red', ax = ax2)
            ax2.legend(ncol=1, loc="upper center", bbox_to_anchor=(0., 0.9, 0.4, .102), frameon=False, fontsize=22)


            ax.set_xlabel("Number of Nodes")
            ax.set_ylabel("Measured Time (seconds)")
            ax.set_yscale('log')
            ax2.set_ylabel("Message Count")
            plt.set_xticks(nodes, nodes)

            ax2.spines['right'].set_color('red')
            ax2.yaxis.label.set_color('red')
            ax2.tick_params(axis='y', colors='red')    

            filename="%s-%s-%s.pdf"%(folder, op, mat.name)
            #plt.display_plot()
            plt.save_plot(filename)
            #plt.plt.savefig(filename, bbox_inches = "tight", transparent=True)
            plt.plt.clf()
            #plt.plt.savefig("%s.pdf"%mat_name, )            
