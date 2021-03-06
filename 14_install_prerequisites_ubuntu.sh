# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Installing UBUNTU prerequisites for CP4WAIOPS 3.1
#
# V3.1.1
#
# ©2021 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 CloudPak for Watson AI OPS 3.1 - Install UBUNTU Prerequisites"
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "


echo "🚀 Installing prerequisites"
echo ""

    echo "   🧰 Install Tools"
    echo ""  
        echo "      📥 Install kafkacat"
        sudo apt-get install -y kafkacat
        
        echo "      📥 Install npm"
        sudo apt-get install -y npm
        
        echo "      📥 Install elasticdump"
        sudo npm install elasticdump -g
        
        echo "      📥 Install jq"
        sudo apt-get install -y jq

        echo "      📥 Install cloudctl"
        curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz -o cloudctl-linux-amd64.tar.gz
        tar xfvz cloudctl-linux-amd64.tar.gz
        sudo mv cloudctl-linux-amd64 /usr/local/bin/cloudctl
        rm cloudctl-linux-amd64.tar.gz

        echo "      📥 Install helm"
        wget -L https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz -O helm.tar.gz
        tar xfvz helm.tar.gz
        sudo mv linux-amd64/helm /usr/local/bin/helm
        sudo rm -r linux-amd64/
        sudo rm helm.tar.gz
        
    echo ""  
    echo "" 
    echo ""  
    echo "   🧰 Install OpenShift Client"
    echo ""  
        wget https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-07-03-190901/openshift-client-linux-4.7.0-0.okd-2021-07-03-190901.tar.gz -O oc.tar.gz
        tar xfzv oc.tar.gz
        sudo mv oc /usr/local/bin
        sudo mv kubectl /usr/local/bin
        rm oc.tar.gz
        rm README.md

    echo ""  
    echo ""  
    echo ""  
    echo "   🧰 Install K9s"
    echo ""  
        wget https://github.com/derailed/k9s/releases/download/v0.24.15/k9s_Linux_x86_64.tar.gz
        tar xfzv k9s_Linux_x86_64.tar.gz
        sudo mv k9s /usr/local/bin
        rm LICENSE
        rm README.md

        

echo ""  
echo ""  
echo "Installing prerequisites DONE..."



echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo " ✅ Prerequisites Installed"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"



