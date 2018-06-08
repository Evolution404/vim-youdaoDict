### 说明 ###

这个插件调用的是有道的openapi进行翻译的，需要vim支持python
并且使用的时候需要网络

### 安装 ###

通过 `:echo has('python')` 检查vim是否支持python。
最简单的安装方式就是使用vim插件管理器，比如 [vundle][vundle]

使用vundle安装：

    Plugin 'Evolution404/vim-youdao'

    :PluginInstall

### 使用和设置 ###

以下是默认的有道openapi的key：

    let g:api_key = "1932136763"
    let g:keyfrom = "aioiyuuko"

你可以设置成你自己申请的

**mac下可以自动使用say命令对查询的单词进行朗读,进入窗口r键可以重复朗读**

默认快捷键绑定：

    --普通模式下，<Leader>w 即可翻译光标下的文本，并且在Dict新窗口显示
    --可视化模式下，<Leader>w 即可翻译选中的文本，并且在Dict新窗口显示

**Dict窗口中 `q` 键关闭Dict窗口**

在vim配置文件中，可以把 `<Leader>w` 配置为你设置的快捷键

默认命令：

    command! -nargs=1 DictW call dict#Search(<q-args>, 'complex')
    --使用 :DictW hello 在Dict新窗口显示

在vim配置文件中，可以把 或者 `DictW` 配置为你设置的命令

