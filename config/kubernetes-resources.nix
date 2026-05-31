{ config, ... }:
{
  sops.secrets."homelab/cloudflare-token-b64" = {};
  sops.templates."cloudflare-token.yaml".content = ''
    apiVersion: v1
    kind: Secret
    metadata:
      name: cloudflare-api-token-secret
      namespace: cert-manager
    type: Opaque
    data:
      api-token: ${config.sops.placeholder."homelab/cloudflare-token-b64"}
  '';

  sops.secrets.argocd-secret = {
    sopsFile = ../secrets/k8s/argocd-secret.yaml;
    key = "";
  };

  sops.secrets.argo-git-ssh = {
    sopsFile = ../secrets/k8s/argo-git-ssh.yaml;
    key = "";
  };

  sops.secrets."homelab/smtp-password" = {};
  sops.templates."alert-manager-creds.yaml".content = ''
    apiVersion: v1
    kind: Secret
    metadata:
      name: alert-manager-creds
      namespace: monitoring
    type: Opaque
    stringData:
      smtp-password: ${config.sops.placeholder."homelab/smtp-password"}
  '';

  sops.secrets.authelia-secrets = {
    sopsFile = ../secrets/k8s/authelia-secrets.yaml;
    key = "";
  };

  sops.secrets.authelia-oidc = {
    sopsFile = ../secrets/k8s/authelia-oidc.yaml;
    key = "";
  };

  sops.secrets.longhorn = {
    sopsFile = ../secrets/k8s/longhorn-secrets.yaml;
    key = "";
  };

  sops.secrets.renovate = {
    sopsFile = ../secrets/k8s/renovate-secrets.yaml;
    key = "";
  };

  sops.secrets.linkwarden = {
    sopsFile = ../secrets/k8s/linkwarden-secrets.yaml;
    key = "";
  };

  sops.secrets.freshrss = {
    sopsFile = ../secrets/k8s/freshrss-secrets.yaml;
    key = "";
  };

  sops.secrets.immich = {
    sopsFile = ../secrets/k8s/immich-secrets.yaml;
    key = "";
  };

  sops.secrets.nextcloud = {
    sopsFile = ../secrets/k8s/nextcloud-secrets.yaml;
    key = "";
  };

  services.k3s = {
    manifests = {
      cert-manager-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "cert-manager";
        };
      };
      cloudflare-api-token-secret.source = config.sops.templates."cloudflare-token.yaml".path;

      argocd-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "argocd";
        };
      };
      argocd-secret.source = config.sops.secrets.argocd-secret.path;
      argo-git-ssh.source = config.sops.secrets.argo-git-ssh.path;
      argocd-apps.content = {
        apiVersion = "argoproj.io/v1alpha1";
        kind = "Application";
        "metadata" = {
          name = "bootstrap";
          namespace = "argocd";
          finalizers = [ "resources-finalizer.argocd.argoproj.io" ];
        };
        spec = {
          destination = {
            server = "https://kubernetes.default.svc";
            namespace = "argocd";
          };
          project = "default";
          source = {
            repoURL = "git@github.com:NigelRook/argo.git";
            targetRevision = "main";
            path = "bootstrap";
          };
        };
      };

      monitoring-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "monitoring";
        };
      };
      alert-manager-creds.source = config.sops.templates."alert-manager-creds.yaml".path;

      authelia-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "authelia";
        };
      };
      authelia-secrets.source = config.sops.secrets.authelia-secrets.path;
      authelia-oidc.source = config.sops.secrets.authelia-oidc.path;

      longhorn-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "longhorn-system";
        };
      };
      longhorn-secrets.source = config.sops.secrets.longhorn.path;

      renovate-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "renovate";
        };
      };
      renovate-secrets.source = config.sops.secrets.renovate.path;

      linkwarden-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "linkwarden";
        };
      };
      linkwarden-secrets.source = config.sops.secrets.linkwarden.path;

      freshrss-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "freshrss";
        };
      };
      freshrss-secrets.source = config.sops.secrets.freshrss.path;

      immich-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "immich";
        };
      };
      immich-secrets.source = config.sops.secrets.immich.path;

      nextcloud-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "nextcloud";
        };
      };
      nextcloud-secrets.source = config.sops.secrets.nextcloud.path;
    };

    # Enable for bootstrapping. Can be disabled after argocd starts
    # self-managing its own helm chart
    autoDeployCharts = {
      argocd = {
        enable = false;
        name = "argo-cd";
        repo = "https://argoproj.github.io/argo-helm";
        version = "9.1.10";
        hash = "";
        targetNamespace = "argocd";
        values = {
          configs = {
            params = {
              "server.insecure" = true;
            };
            secret.createSecret = false;
          };
        };
      };
    };
  };
}
