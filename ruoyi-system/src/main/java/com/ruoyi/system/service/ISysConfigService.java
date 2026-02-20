package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysConfig;

/**
 * Parameter Configuration Service Layer
 * 
 * @author ruoyi
 */
public interface ISysConfigService
{
    /**
     * Query Parameter Configuration Information
     * 
     * @param configId Parameter Configuration ID
     * @return Parameter Configuration Information
     */
    public SysConfig selectConfigById(Long configId);

    /**
     * Query Parameter Configuration Information by Key Name
     * 
     * @param configKey Parameter Key Name
     * @return Parameter Key Value
     */
    public String selectConfigByKey(String configKey);

    /**
     * Get Captcha Switch
     * 
     * @return true enabled, false disabled
     */
    public boolean selectCaptchaEnabled();

    /**
     * Query Parameter Configuration List
     * 
     * @param config Parameter Configuration Information
     * @return Parameter Configuration Collection
     */
    public List<SysConfig> selectConfigList(SysConfig config);

    /**
     * Add Parameter Configuration
     * 
     * @param config Parameter Configuration Information
     * @return Result
     */
    public int insertConfig(SysConfig config);

    /**
     * Modify Parameter Configuration
     * 
     * @param config Parameter Configuration Information
     * @return Result
     */
    public int updateConfig(SysConfig config);

    /**
     * Batch Delete Parameter Information
     * 
     * @param configIds Parameter IDs to Delete
     */
    public void deleteConfigByIds(Long[] configIds);

    /**
     * Load Parameter Cache Data
     */
    public void loadingConfigCache();

    /**
     * Clear Parameter Cache Data
     */
    public void clearConfigCache();

    /**
     * Reset Parameter Cache Data
     */
    public void resetConfigCache();

    /**
     * Validate if Parameter Key Name is Unique
     * 
     * @param config Parameter Information
     * @return Result
     */
    public boolean checkConfigKeyUnique(SysConfig config);
}
