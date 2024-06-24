nodes = 64
for op in ["alltoall", "alltoallv"]:
    mat_names = list()
    std_times = list()
    tor_times = list()
    std_loc_times = list()
    tor_loc_times = list()
    rma_times = list()
    folder = "many_mats"
    f = open("%s/%s_crs.out"%(folder, op))
    for line in f:
        if "CRS-Alltoall/benchmark_mats/" in line:
            mat_name = (line.rsplit('/')[-1]).rsplit('.')[0]
            mat_names.append(mat_name)
        elif "Max" in line or "Time" in line or "time" in line:
            n = (float)((line.rsplit('\n')[0]).rsplit(' ')[-1])
            if "Personalized Locality" in line:
                std_loc_times.append(n)
            elif "Nonblocking Locality" in line:
                tor_loc_times.append(n)
            elif "Personalized" in line:
                std_times.append(n)
            elif "Nonblocking" in line:
                tor_times.append(n)
            elif "RMA" in line:
                rma_times.append(n)
    f.close()

        
    import matplotlib.backends
    import pyfancyplot as plt
    import matplotlib
    matplotlib.use("TkAgg")
    import numpy as np

    xdata = np.arange(len(mat_names))
    n_col = 2
    plt.add_luke_options()
    plt.plt.scatter(xdata, std_times, color="black", label = "Personalized")
    plt.plt.scatter(xdata, tor_times, color="blue", label = "NonBlocking")
    plt.plt.scatter(xdata, std_loc_times, color="red", label = "Personalized Locality")
    plt.plt.scatter(xdata, tor_loc_times, color="green", label = "NonBlocking Locality")
    if (op == "alltoall"):
        plt.plt.scatter(xdata, rma_times, color="orange", label = "RMA")
    plt.add_anchored_legend()
    plt.set_xticks(xdata, mat_names, rotation='vertical', fontsize=10)
    print(mat_names)

    filename="%s-%s.pdf"%(folder, op)
    #plt.display_plot()
    plt.save_plot(filename)
    #plt.plt.savefig(filename, bbox_inches = "tight", transparent=True)
    plt.plt.clf()
    #plt.plt.savefig("%s.pdf"%mat_name, )            
