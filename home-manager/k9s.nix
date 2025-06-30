{pkgs-unstable, ...}: {
  programs.k9s = {
    enable = true;

    # plugins = {
    #   dive = {
    #     args = [
    #       "\${COL-IMAGE}"
    #     ];

    #     background = false;
    #     command = "dive";
    #     confirm = false;
    #     description = "Dive image";

    #     scopes = [
    #       "containers"
    #     ];

    #     shortCut = "d";
    #   };

    #   debug = {
    #     args = [
    #       "-c"
    #       "kubectl debug --image nicolaka/netshoot:v0.13 --kubeconfig \${KUBECONFIG} --namespace \${NAMESPACE} \${POD} --share-processes --stdin --target \${NAME} --tty -- bash"
    #     ];

    #     background = false;
    #     command = "bash";
    #     confirm = true;
    #     dangerous = true;
    #     description = "Add debug container";

    #     scopes = [
    #       "containers"
    #     ];

    #     shortCut = "Shift-D";
    #   };
    # };

    package = pkgs-unstable.k9s;

    settings = {
      readOnly = true;
      refreshRate = 1;
    };
  };
}
